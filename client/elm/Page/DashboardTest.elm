module Page.DashboardTest exposing (dashboardTest)

import Expect
import Html
import Page.Dashboard as Dashboard
import Project
import Random.Pcg.Extended as Random
import Session
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, class, id, tag, text)


fakeUser : Session.User
fakeUser =
    ( Session.LoggedIn, Just { username = "Crowdfunder" } )


fakeSeed : Random.Seed
fakeSeed =
    Random.initialSeed 1 [ 1, 2, 3 ]


fakeProject : Project.Project
fakeProject =
    { uuid = Nothing
    , address = Nothing
    , description = "Project description"
    , featuredImageUrl = "https://image.jpg"
    , goal = 10.0
    , isSaved = True
    , saving = False
    , title = "My Project"
    }


fakeProjectList : List Project.Project
fakeProjectList =
    [ fakeProject, fakeProject, fakeProject ]


generateDashboardView : Html.Html Dashboard.Msg
generateDashboardView =
    Dashboard.view fakeUser ( fakeProject, fakeProjectList, fakeSeed )


dashboardTest : Test
dashboardTest =
    describe "Dashboard"
        [ describe "route"
            [ test "should be defined" <|
                \_ -> Expect.equal Dashboard.route "dashboard"
            ]
        , describe
            "title"
            [ test "should be defined" <|
                \_ -> Expect.equal Dashboard.title "Blocos app"
            ]
        , describe
            "view"
            [ test "should show username" <|
                \_ ->
                    let
                        ( _, user ) =
                            fakeUser

                        username =
                            case user of
                                Just userData ->
                                    userData.username

                                Nothing ->
                                    ""
                    in
                    generateDashboardView
                        |> Query.fromHtml
                        |> Query.find [ class "text" ]
                        |> Query.has [ text username ]
            , test "shold list the user projects" <|
                \_ ->
                    generateDashboardView
                        |> Query.fromHtml
                        |> Query.findAll [ class "project-link" ]
                        |> Query.count (Expect.equal <| List.length fakeProjectList)
            ]
        ]
