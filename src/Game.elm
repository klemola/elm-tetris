module Game exposing (..)

import Time exposing (Time)
import Random exposing (Generator, Seed)
import Tetromino exposing (Tetromino)
import Controller exposing (..)
import Board exposing (Board, testBoard)


type alias Model =
    { falling : Tetromino
    , seed : Seed
    , bag : List Tetromino
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


initialSeed : number
initialSeed =
    42


defaultModel : Model
defaultModel =
    let
        ( bag, seed ) =
            Random.step Tetromino.bag (Random.initialSeed initialSeed)

        falling =
            List.head bag
                |> Maybe.withDefault Tetromino.i

        bag_ =
            List.drop 1 bag
    in
        { falling = firstTetromino
        , seed = seed
        , bag = bag_
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


checkBag : Model -> Model
checkBag model =
    if not (List.isEmpty model.bag) then
        model
    else
        let
            ( bag, seed ) =
                Random.step Tetromino.bag model.seed
        in
            { model
                | bag = bag
                , seed = seed
            }


nextTetromino : Model -> Model
nextTetromino model =
    let
        model_ =
            checkBag model

        nextFalling =
            List.head model_.bag
                |> Maybe.withDefault Tetromino.i
                |> Tetromino.shift startingShift

        nextBag =
            List.drop 1 model.bag

        ( lines, nextBoard ) =
            Board.addTetromino model_.falling model_.board
                |> Board.clearLines
    in
        { model_
            | falling = nextFalling
            , bag = nextBag
            , board = nextBoard
        }


checkTick : Model -> Model
checkTick model =
    if model.time < model.nextShift then
        model
    else
        let
            nextFalling =
                Tetromino.shift ( -1, 0 ) model.falling

            nextShift =
                model.time + model.shiftDelay

            isValid =
                Board.isValid nextFalling model.board

            model_ =
                if isValid then
                    { model | falling = nextFalling }
                else
                    nextTetromino model
        in
            { model_
                | nextShift = nextShift
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
