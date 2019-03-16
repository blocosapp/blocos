module ProjectTest exposing (projectTest)

import Expect exposing (Expectation)
import Html exposing (Html)
import Html.Attributes
import Project
import Random.Pcg.Extended as Random
import Session
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, class, classes, id, tag)


userMock : Session.User
userMock =
    ( Session.LoggedIn, Just { username = "Neymar Jr." } )


seedMock : Random.Seed
seedMock =
    Random.initialSeed 1 [ 1, 2, 3 ]


savingProject : Project.Project
savingProject =
    { uuid = Nothing
    , address = Nothing
    , description = "Project description"
    , featuredImageUrl = "https://image.jpg"
    , goal = 10.0
    , isSaved = False
    , saving = True
    , title = "My Project"
    }


createProjectView : Html Project.Msg
createProjectView =
    Project.createProjectView userMock ( Project.emptyProject, [], seedMock )


createProjectViewWithSavingProject : Html Project.Msg
createProjectViewWithSavingProject =
    Project.createProjectView userMock ( savingProject, [], seedMock )


projectTest : Test
projectTest =
    describe
        "Project"
        [ describe "createProjectRoute"
            [ test "should return url in string format" <|
                \_ -> Expect.equal Project.createProjectRoute "/projects/new"
            ]
        , describe
            "createProjectTitle"
            [ test "should return a string with a title for the page" <|
                \_ -> Expect.equal Project.createProjectTitle "Create your new descentralized crowdfunding project - Blocos"
            ]
        , describe
            "emptyProject"
            [ test "should return an empty project" <|
                \_ ->
                    Expect.equal Project.emptyProject
                        { uuid = Nothing
                        , title = ""
                        , description = ""
                        , featuredImageUrl = ""
                        , goal = 0.0
                        , isSaved = False
                        , saving = False
                        , address = Nothing
                        }
            ]
        , describe
            "createProjectView"
            [ test "should render a form" <|
                \_ ->
                    createProjectView
                        |> Query.fromHtml
                        |> Query.has [ tag "form" ]
            , test "should render the create project form inputs" <|
                \_ ->
                    createProjectView
                        |> Query.fromHtml
                        |> Query.findAll [ tag "input" ]
                        |> Query.count (Expect.equal 3)
            , test "should render the saving label when the project is being saved" <|
                \_ ->
                    createProjectViewWithSavingProject
                        |> Query.fromHtml
                        |> Query.find [ class "submit" ]
                        |> Query.has [ attribute <| Html.Attributes.value "Saving..." ]
            ]
        ]
