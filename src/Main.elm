module Tetris exposing (..)

import Element exposing (show, flow, down)
import Collage
import Html exposing (Html, div, text, program)
import Html.Attributes exposing (style)
import Game
import Controller exposing (..)
import Board


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
    , windowSize = ( 600, 600 )
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

        visuals =
            [ tetris.game.board
                |> Board.addTetromino tetris.game.falling
                |> Board.toForm
            ]

        coll =
            Collage.collage w h visuals

        falling =
            show tetris.game.falling.shape

        timer =
            show ("Time " ++ toString (floor (tetris.game.time / 1000)))

        inBounds =
            show (Board.inBounds tetris.game.falling)

        -- TODO check why Tetromino is always intersecting here
        isIntersecting =
            show (Board.isIntersecting tetris.game.falling tetris.game.board)

        contents =
            flow down
                [ coll
                , falling
                , timer
                , inBounds
                , isIntersecting
                ]
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
                [ Element.toHtml contents
                ]
            ]
