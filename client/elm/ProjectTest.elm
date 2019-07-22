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


userData : Session.UserData
userData =
    { username = "John Doe"
    , name = Nothing
    , profilePicture = Nothing
    }


userMock : Session.User
userMock =
    ( Session.LoggedIn, Just userData )


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
    , cardImageUrl = "https://card.png"
    , coverImageUrl = "https://cover.png"
    , description = "Mocked project"
    , duration = 60
    , goal = 10
    , rewards = []
    , projectHash = ""
    , projectHubUrl = ""
    , projectVideoUrl = "https://ytb.c"
    , status = Project.Saving
    , tagline = "Project tagline"
    , title = "My Mocked Project"
    }


savingProject : Project.Project
savingProject =
    { uuid = Nothing
    , address = Nothing
    , cardImageUrl = "https://card.jpg"
    , coverImageUrl = "https://cover.jpg"
    , description = "Project description"
    , duration = 60
    , goal = 10.0
    , rewards = []
    , projectHash = ""
    , projectHubUrl = ""
    , projectVideoUrl = "https://ytb.c"
    , status = Project.Saving
    , tagline = "tagline"
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
                \_ -> Expect.equal Project.createProjectTitle "Create your new decentralized crowdfunding project - Blocos"
            ]
        , describe
            "emptyProject"
            [ test "should return an empty project" <|
                \_ ->
                    Expect.equal Project.emptyProject
                        { uuid = Nothing
                        , address = Nothing
                        , cardImageUrl = ""
                        , coverImageUrl = ""
                        , description = ""
                        , duration = 60
                        , goal = 0.0
                        , projectHash = ""
                        , projectHubUrl = ""
                        , projectVideoUrl = ""
                        , rewards = []
                        , status = Project.Saved
                        , tagline = ""
                        , title = ""
                        }
            ]
        , describe
            "createProjectView"
            [ test "should render the saving label when the project is being saved" <|
                \_ ->
                    createProjectViewWithSavingProject
                        |> Query.fromHtml
                        |> Query.find [ class "-save" ]
                        |> Query.has [ attribute <| Html.Attributes.value "Saving..." ]
            ]
        ]
