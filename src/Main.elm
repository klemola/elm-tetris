module Tetris exposing (..)

import Element
import Collage
import Html exposing (Html, div, text, program)
import Html.Attributes exposing (style)
import Game
import Controller exposing (..)
import Tetromino


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : ( Model, Cmd Msg )
init =
    defaultTetris ! []


subscriptions : Model -> Sub Msg
subscriptions model =
    Controller.subscriptions |> Sub.map ControllerMsg


type alias Model =
    Tetris


type alias Tetris =
    { windowSize : ( Int, Int )
    , controller : Controller.Model
    , game : Game.Model
    }


type Msg
    = ControllerMsg Controller.Msg


defaultTetris : Tetris
defaultTetris =
    { controller = Nothing
    , windowSize = ( 400, 400 )
    , game = Game.defaultModel
    }


update : Msg -> Tetris -> ( Tetris, Cmd Msg )
update msg model =
    case msg of
        ControllerMsg x ->
            let
                ( newModel, input ) =
                    Controller.update x model.controller

                tetris =
                    { model | controller = newModel }
            in
                { tetris | game = Game.update input model.game } ! []


view : Tetris -> Html Msg
view tetris =
    let
        ( w, h ) =
            tetris.windowSize

        coll =
            Collage.collage w h
    in
        div
            [ style
                [ ( "position", "absolute" )
                , ( "background", "#ccc" )
                , ( "top", "0" )
                , ( "bottom", "0" )
                , ( "left", "0" )
                , ( "right", "0" )
                , ( "text-align", "center" )
                ]
            ]
            [ div
                [ style
                    [ ( "position", "relative" )
                    , ( "margin", "10px auto" )
                    , ( "display", "inline-block" )
                    ]
                ]
                [ text ("Time " ++ toString (floor (tetris.game.time / 1000)))
                , Element.toHtml (coll [ Tetromino.toForm tetris.game.falling ])
                ]
            ]
