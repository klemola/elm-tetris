module Tetromino exposing (..)

import Block exposing (Block)
import Color exposing (Color)
import Collage exposing (..)
import Random exposing (Generator, float)


type alias Location =
    ( Int, Int )


type alias Pivot =
    { row : Float
    , col : Float
    }


type alias Tetromino =
    { shape : List Location
    , block : Block
    , pivot : Pivot
    , rows : Int
    , cols : Int
    }


i : Tetromino
i =
    { shape =
        [ ( 1, 0 )
        , ( 0, 0 )
        , ( -1, 0 )
        , ( -2, 0 )
        ]
    , block = Block Color.lightBlue
    , pivot = { row = -0.5, col = 0.5 }
    , rows = 4
    , cols = 1
    }


j : Tetromino
j =
    { shape =
        [ ( 1, 0 )
        , ( 0, 0 )
        , ( -1, 0 )
        , ( -1, -1 )
        ]
    , block = Block Color.blue
    , pivot = { row = 0.0, col = 0.0 }
    , rows = 3
    , cols = 2
    }


l : Tetromino
l =
    { shape =
        [ ( 1, 0 )
        , ( 0, 0 )
        , ( -1, 0 )
        , ( -1, 1 )
        ]
    , block = Block Color.orange
    , pivot = { row = 0.0, col = 0.0 }
    , rows = 3
    , cols = 2
    }


z : Tetromino
z =
    { shape =
        [ ( -1, 1 )
        , ( 1, 0 )
        , ( 0, 0 )
        , ( 0, 1 )
        ]
    , block = Block Color.red
    , pivot = { row = 0.0, col = 0.0 }
    , rows = 2
    , cols = 3
    }


s : Tetromino
s =
    { shape =
        [ ( 0, 0 )
        , ( 0, 1 )
        , ( -1, -1 )
        , ( -1, 0 )
        ]
    , block = Block Color.green
    , pivot = { row = 0.0, col = 0.0 }
    , rows = 2
    , cols = 3
    }


t : Tetromino
t =
    { shape =
        [ ( 0, -1 )
        , ( 0, 0 )
        , ( 0, 1 )
        , ( -1, 0 )
        ]
    , block = Block Color.purple
    , pivot = { row = 0, col = 0 }
    , rows = 2
    , cols = 3
    }


o : Tetromino
o =
    { shape =
        [ ( 0, 0 )
        , ( 0, 1 )
        , ( -1, 0 )
        , ( -1, 1 )
        ]
    , block = Block Color.yellow
    , pivot = { row = -0.5, col = 0.5 }
    , rows = 2
    , cols = 2
    }


toForm : Tetromino -> Form
toForm { shape, block } =
    let
        form =
            Block.toForm block

        translate ( row, col ) =
            move ( toFloat (col) * Block.size, (toFloat row) * Block.size ) form

        forms =
            List.map translate shape
    in
        group forms


drawPivot : Tetromino -> Form
drawPivot { pivot } =
    let
        dot =
            circle 5
                |> filled Color.black

        translate =
            move ( pivot.col * Block.size, pivot.row * Block.size )
    in
        translate dot


rotateLocation : Pivot -> Float -> Location -> Location
rotateLocation pivot angle ( row, col ) =
    let
        rowOrigin =
            (toFloat row - pivot.row)

        colOrigin =
            (toFloat col - pivot.col)

        ( s, c ) =
            ( sin (angle), cos (angle) )

        rowRotated =
            rowOrigin * c - colOrigin * s

        colRotated =
            rowOrigin * s - colOrigin * c
    in
        ( round <| rowRotated + pivot.row, round <| colRotated + pivot.col )


rotate : Tetromino -> Tetromino
rotate tetromino =
    let
        rotateHelper =
            rotateLocation tetromino.pivot (degrees 90)

        newShape =
            List.map rotateHelper tetromino.shape
    in
        { tetromino
            | shape = newShape
            , rows = tetromino.cols
            , cols = tetromino.rows
        }


shift : ( Int, Int ) -> Tetromino -> Tetromino
shift ( rows, cols ) tetromino =
    let
        shiftHelper ( row, col ) =
            ( row + rows, col + cols )

        newShape =
            List.map shiftHelper tetromino.shape

        pivot_ =
            { row = tetromino.pivot.row + (toFloat rows), col = tetromino.pivot.col + (toFloat cols) }
    in
        { tetromino | shape = newShape, pivot = pivot_ }


zeroToOne : Generator Float
zeroToOne =
    float 0 1


shuffleBag : List Float -> List Tetromino
shuffleBag weights =
    let
        tetrominoes =
            [ i, o, j, l, z, s, t ]

        weighted =
            List.map2 (,) weights tetrominoes

        sorted =
            List.sortBy Tuple.first weighted
    in
        List.map Tuple.second sorted


bag : Generator (List Tetromino)
bag =
    let
        weights =
            Random.list 7 zeroToOne
    in
        Random.map shuffleBag weights
