module ProjectTest exposing (projectTest)

import Expect exposing (Expectation)
import Html exposing (Html)
import Html.Attributes
import Prng.Uuid as Uuid
import Project
import Random.Pcg.Extended as Random
import Session
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, class, classes, id, tag)


userMock : Session.User
userMock =
    ( Session.LoggedIn, Just { username = "Neymar Jr." } )


uuidMocks : List String
uuidMocks =
    [ "54a77172-211d-4b1a-ac3e-dd68a9e5d4a8"
    , "a9964d88-188a-43b4-9aa4-40293cf58317"
    , "cb81de12-da06-412e-a54d-82b27f469554"
    ]


seedMock : Random.Seed
seedMock =
    Random.initialSeed 1 [ 1, 2, 3 ]


projectMocker : String -> Project.Project
projectMocker uuidMock =
    { uuid = Uuid.fromString uuidMock
    , address = Nothing
    , description = "Mocked project"
    , featuredImageUrl = "https://project.png"
    , goal = 10
    , isSaved = False
    , saving = True
    , title = "My Mocked Project"
    }


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
        , describe "getEditProjectRoute"
            [ test "should return url that leads to project edit in string format" <|
                let
                    uuid =
                        Maybe.withDefault "" (List.head uuidMocks)

                    expected =
                        "/projects/edit/" ++ uuid

                    result =
                        Project.getEditProjectRoute (projectMocker uuid)
                in
                \_ -> Expect.equal expected result
            ]
        , describe "setCurrentProjectByUuidString"
            [ test "should set the current project in projects' model based on it's uuid string" <|
                let
                    projects =
                        List.map (\uuidMock -> projectMocker uuid) uuidMocks

                    modelBefore =
                        ( Project.emptyProject, projects, seedMock )

                    uuid =
                        case uuidMocks of
                            x :: xs ->
                                x

                            _ ->
                                ""

                    expected =
                        case projects of
                            x :: xs ->
                                ( x, projects, seedMock )

                            _ ->
                                ( Project.emptyProject, [], seedMock )

                    result =
                        Project.setCurrentProjectByUuidString uuid modelBefore
                in
                \_ -> Expect.equal expected result
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
