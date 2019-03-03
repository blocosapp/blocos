module SkeletonTest exposing (skeletonTest)

import Expect
import Html
import Html.Attributes as Attributes
import Session
import Skeleton
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, class, classes, id, tag, text)


testView : Html.Html Msg
testView =
    Html.div [ Attributes.class "test-view" ] [ Html.text "test view rendered" ]


testApplicationView : Html.Html Msg
testApplicationView =
    Html.div [ Attributes.class "test-view" ] [ Html.text "test view rendered" ]


type Msg
    = Msg


type ViewMsg
    = TestViewMsg Msg
    | SessionMsg Session.Msg


skeletonTest : Test
skeletonTest =
    describe "Skeleton"
        [ describe "content"
            [ test "should wrap the view in an application skeleton" <|
                \_ ->
                    Skeleton.content TestViewMsg testView
                        |> Query.fromHtml
                        |> Expect.all
                            [ Query.has [ classes [ "logo", "-big" ] ]
                            , Query.has [ class "test-view" ]
                            , Query.has [ class "footer" ]
                            ]
            ]
        , describe
            "application"
            [ test "should wrap the view in a content skeleton" <|
                \_ ->
                    Skeleton.application TestViewMsg SessionMsg testApplicationView
                        |> Query.fromHtml
                        |> Expect.all
                            [ Query.has [ class "logo" ]
                            , Query.hasNot [ class "-big" ]
                            , Query.has [ class "dashboard" ]
                            , Query.has [ class "footer" ]
                            ]
            ]
        ]
