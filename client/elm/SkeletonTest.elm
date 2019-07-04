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


testApplicationViewID : String
testApplicationViewID =
    "application-test-view"


testApplicationView : Html.Html Msg
testApplicationView =
    Html.div [ Attributes.id testApplicationViewID ] [ Html.text "test view rendered" ]


type Msg
    = Msg


type ViewMsg
    = TestViewMsg Msg
    | SessionMsg Session.Msg
    | SkeletonMsg Skeleton.Msg


skeletonModel : Skeleton.Model
skeletonModel =
    Skeleton.Opened


anonymousUser : Session.User
anonymousUser =
    ( Session.Anonymous, Nothing )


loggedInUser : Session.User
loggedInUser =
    ( Session.LoggedIn, Just { username = "user", name = Nothing, profilePicture = Nothing } )


skeletonTest : Test
skeletonTest =
    describe "Skeleton"
        [ describe "content"
            [ test "should wrap the view in an application skeleton" <|
                \_ ->
                    Skeleton.content TestViewMsg SessionMsg loggedInUser testView
                        |> Query.fromHtml
                        |> Expect.all [ Query.has [ id "link-app" ] ]
            , test "should show sign in button if user is anonymous" <|
                \_ ->
                    Skeleton.content TestViewMsg SessionMsg anonymousUser testView
                        |> Query.fromHtml
                        |> Expect.all [ Query.has [ id "sign-in" ] ]
            ]
        , describe
            "application"
            [ test "should wrap the view in a content skeleton if the user is signed in" <|
                \_ ->
                    Skeleton.application TestViewMsg SessionMsg SkeletonMsg loggedInUser skeletonModel testApplicationView
                        |> Query.fromHtml
                        |> Expect.all
                            [ Query.has [ class "dashboard" ]
                            , Query.has [ id testApplicationViewID ]
                            , Query.has [ class "footer" ]
                            ]
            , test "should not render application data and render sign in info when the user is not authenticated" <|
                \_ ->
                    Skeleton.application TestViewMsg SessionMsg SkeletonMsg anonymousUser skeletonModel testApplicationView
                        |> Query.fromHtml
                        |> Expect.all
                            [ Query.hasNot [ id testApplicationViewID ]
                            , Query.has [ id "sign-in" ]
                            ]
            ]
        ]
