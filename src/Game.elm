module Game exposing (..)

import Tetromino exposing (Tetromino)
import Controller exposing (..)
import Time exposing (Time)


type alias Model =
    { falling : Tetromino
    , time : Time
    , nextShift : Time
    , shiftDelay : Time
    }


type InputAction
    = Rotate
    | Shift ( Int, Int )


defaultModel : Model
defaultModel =
    { falling = Tetromino.i
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
        { model
            | falling = Tetromino.shift ( -1, 0 ) model.falling
            , nextShift = model.time + model.shiftDelay
        }


update : Input -> Model -> Model
update input model =
    case input of
        Direction dir ->
            case toAction dir of
                Rotate ->
                    { model | falling = Tetromino.rotate model.falling }

                Shift pos ->
                    { model | falling = Tetromino.shift pos model.falling }

        Frame _ f ->
            checkTick { model | time = model.time + f }

        _ ->
            model
