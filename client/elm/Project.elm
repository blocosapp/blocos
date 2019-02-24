module Project exposing (Model, Msg, Project, createProjectRoute, createProjectTitle, createProjectView, emptyProject, update)

import Browser
import Html
import Html.Attributes as Attributes
import Html.Events as Events
import Json.Encode as Encode
import List
import Port.Blockstack as Blockstack
import Random.Pcg.Extended as Random
import Session
import String
import Url.Builder
import Uuid


type alias Project =
    { id : Maybe Uuid.Uuid
    , address : Maybe String -- @TODO strongly type blockchain address
    , description : String
    , featuredImageUrl : String -- @TODO check if we can strongly type this URI
    , goal : Float
    , title : String
    }


type alias Model =
    ( Project, List Project, Random.Seed )


emptyProject : Project
emptyProject =
    { id = Nothing
    , title = ""
    , description = ""
    , featuredImageUrl = ""
    , goal = 0.0
    , address = Nothing
    }


type Msg
    = SaveProject
    | ChangeTitle String
    | ChangeDescription String
    | ChangeGoal String


projectToFile : Project -> Uuid.Uuid -> Blockstack.ProjectFile
projectToFile project uuid =
    { address = project.address
    , description = project.description
    , goal = project.goal
    , title = project.title
    , id = Uuid.toString uuid
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg ( project, projects, seed ) =
    case msg of
        SaveProject ->
            let
                ( uuid, newSeed ) =
                    Random.step Uuid.generator seed
            in
            ( ( emptyProject, projects, newSeed ), Blockstack.putFile (projectToFile project uuid) )

        ChangeDescription newDescription ->
            ( ( { project | description = newDescription }, projects, seed ), Cmd.none )

        ChangeTitle newTitle ->
            ( ( { project | title = newTitle }, projects, seed ), Cmd.none )

        ChangeGoal maybeNewGoal ->
            let
                newGoal =
                    case String.toFloat maybeNewGoal of
                        Just goal ->
                            goal

                        Nothing ->
                            0.0
            in
            ( ( { project | goal = newGoal }, projects, seed ), Cmd.none )


createProjectRoute : String
createProjectRoute =
    Url.Builder.absolute [ "projects", "new" ] []


createProjectTitle : String
createProjectTitle =
    "Create your new descentralized crowdfunding project - Blocos"


createProjectView : Session.User -> Model -> Html.Html Msg
createProjectView user ( currentProject, projects, seed ) =
    let
        username =
            case user of
                ( Session.LoggedIn, Just userData ) ->
                    userData.username

                _ ->
                    "Anonymous"
    in
    Html.section [ Attributes.class "create-project" ]
        [ Html.h1 [ Attributes.class "tittle" ] [ Html.text "Create your new project" ]
        , Html.form
            [ Attributes.class "form form-project"
            , Attributes.name "project"
            , Attributes.action "#"
            , Events.onSubmit SaveProject
            ]
            [ Html.fieldset
                [ Attributes.class "fieldset" ]
                [ Html.label
                    [ Attributes.class "label"
                    , Attributes.for "project-title"
                    ]
                    [ Html.text "Title" ]
                , Html.input
                    [ Attributes.id "project-title"
                    , Attributes.class "input"
                    , Attributes.type_ "text"
                    , Attributes.value currentProject.title
                    , Attributes.placeholder "Project title"
                    , Events.onInput ChangeTitle
                    ]
                    []
                ]
            , Html.fieldset
                [ Attributes.class "fieldset" ]
                [ Html.label
                    [ Attributes.class "label"
                    , Attributes.for "project-goal"
                    ]
                    [ Html.text "Goal (in btc)" ]
                , Html.input
                    [ Attributes.class "input"
                    , Attributes.for "project-goal"
                    , Attributes.type_ "number"
                    , Attributes.step ".0000001"
                    , Attributes.value <| String.fromFloat currentProject.goal
                    , Attributes.placeholder "0.0003"
                    , Events.onInput ChangeGoal
                    ]
                    []
                ]
            , Html.fieldset
                [ Attributes.class "fieldset" ]
                [ Html.label
                    [ Attributes.class "label"
                    , Attributes.for "project-description"
                    ]
                    [ Html.text "Description" ]
                , Html.textarea
                    [ Attributes.class "input textarea"
                    , Attributes.name "project-description"
                    , Attributes.placeholder "Let's fix the world, 1 btc at a time"
                    , Events.onInput ChangeDescription
                    ]
                    [ Html.text currentProject.description ]
                ]
            , Html.input
                [ Attributes.class "submit button -reverse"
                , Attributes.type_ "submit"
                , Attributes.value "Save"
                ]
                []
            ]
        ]
