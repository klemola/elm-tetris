module Game exposing (..)

import Time exposing (Time)
import Tetromino exposing (Tetromino)
import Controller exposing (..)
import Board exposing (Board, testBoard)


type alias Model =
    { falling : Tetromino
    , board : Board
    , time : Time
    , nextShift : Time
    , shiftDelay : Time
    }


type InputAction
    = Rotate
    | Shift ( Int, Int )


startingShift : ( Int, Int )
startingShift =
    ( 20, 5 )


firstTetromino : Tetromino
firstTetromino =
    Tetromino.l
        |> Tetromino.shift startingShift


defaultModel : Model
defaultModel =
    { falling = firstTetromino
    , board = Board.new []
    , time = 0
    , nextShift = Time.second
    , shiftDelay = Time.second
    }


toAction : Direction -> InputAction
toAction direction =
    case direction of
        Up ->
            Rotate

        Down ->
            Shift ( -1, 0 )

        Right ->
            Shift ( 0, 1 )

        Left ->
            Shift ( 0, -1 )

        None ->
            Shift ( 0, 0 )


checkTick : Model -> Model
checkTick model =
    if model.time < model.nextShift then
        model
    else
        let
            nextFalling =
                Tetromino.shift ( -1, 0 ) model.falling
        in
            { model
                | falling = nextFalling
                , nextShift = model.time + model.shiftDelay
            }


useIfValid : Model -> Model -> Model
useIfValid current new =
    if Board.isValid new.falling new.board then
        new
    else
        current


tryKicks : List ( Int, Int ) -> Model -> Model -> Model
tryKicks shifts current new =
    case shifts of
        [] ->
            current

        s :: rest ->
            let
                shifted =
                    Tetromino.shift s new.falling
            in
                if Board.isValid shifted new.board then
                    { new | falling = shifted }
                else
                    tryKicks rest current new


wallKick : Model -> Model -> Model
wallKick current new =
    let
        range =
            new.falling.cols // 2

        shifts =
            List.range 1 range |> List.concatMap (\n -> [ ( 0, n ), ( 0, -n ) ])
    in
        tryKicks shifts current new


floorKick : Model -> Model -> Model
floorKick current new =
    let
        range =
            new.falling.rows // 2

        shifts =
            List.range 1 range |> List.concatMap (\n -> [ ( n, 0 ) ])
    in
        tryKicks shifts current new


update : Input -> Model -> Model
update input model =
    let
        useIfValid_ =
            useIfValid model
    in
        case input of
            Direction dir ->
                case toAction dir of
                    Rotate ->
                        let
                            rotated =
                                { model | falling = Tetromino.rotate model.falling }

                            nextModel =
                                useIfValid_ rotated

                            nextModel_ =
                                if nextModel == model then
                                    wallKick model rotated
                                else
                                    nextModel

                            nextModel__ =
                                if nextModel_ == model then
                                    floorKick model rotated
                                else
                                    nextModel_
                        in
                            nextModel__

                    Shift pos ->
                        useIfValid_ { model | falling = Tetromino.shift pos model.falling }

            Frame _ f ->
                useIfValid_ <| checkTick { model | time = model.time + f }

            _ ->
                model
