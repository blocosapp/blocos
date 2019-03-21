module Project exposing (Model, Msg, Project, createProjectRoute, createProjectTitle, createProjectView, emptyProject, subscriptions, update)

import Browser
import Browser.Navigation as Nav
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
    { uuid : Maybe Uuid.Uuid
    , address : Maybe String -- @TODO strongly type blockchain address
    , description : String
    , featuredImageUrl : String -- @TODO check if we can strongly type this URI
    , goal : Float
    , isSaved : Bool
    , saving : Bool
    , title : String
    }


type alias Model =
    ( Project, List Project, Random.Seed )


emptyProject : Project
emptyProject =
    { uuid = Nothing
    , address = Nothing
    , description = ""
    , featuredImageUrl = ""
    , goal = 0.0
    , isSaved = False
    , saving = False
    , title = ""
    }


type Msg
    = SaveProject
    | ProjectSaved Blockstack.ProjectFile
    | ChangeTitle String
    | ChangeDescription String
    | ChangeGoal String


parseProjectToFile : Project -> Blockstack.ProjectFile
parseProjectToFile project =
    let
        uuidString =
            case project.uuid of
                Just uuid ->
                    Uuid.toString uuid

                Nothing ->
                    ""
    in
    { address = project.address
    , description = project.description
    , featuredImageUrl = project.featuredImageUrl
    , goal = project.goal
    , title = project.title
    , uuid = uuidString
    }


parseFileToProject : Blockstack.ProjectFile -> Project
parseFileToProject projectFile =
    { uuid = Uuid.fromString projectFile.uuid
    , address = projectFile.address
    , description = projectFile.description
    , featuredImageUrl = projectFile.featuredImageUrl
    , isSaved = True
    , saving = False
    , goal = projectFile.goal
    , title = projectFile.title
    }


updateIfProject : Project -> Project -> Project
updateIfProject savingProject projectOnList =
    if savingProject.uuid == projectOnList.uuid then
        savingProject

    else
        projectOnList


hasProject : List Project -> Project -> Bool
hasProject projects project =
    List.any (\currentProject -> currentProject.uuid == project.uuid) projects


reconcileProjects : List Project -> Project -> List Project
reconcileProjects projects project =
    if hasProject projects project then
        List.map (updateIfProject project) projects

    else
        project :: projects


setUuidIfEmpty : Project -> Random.Seed -> ( Project, Random.Seed )
setUuidIfEmpty project seed =
    case project.uuid of
        Just uuid ->
            ( project, seed )

        Nothing ->
            let
                ( newUuid, newSeed ) =
                    Random.step Uuid.generator seed
            in
            ( { project | uuid = Just newUuid }, newSeed )


redirectToProjectList : Nav.Key -> Cmd Msg
redirectToProjectList navKey =
    Nav.pushUrl navKey (Url.Builder.absolute [ "dashboard" ] [])


subscriptions : Sub Msg
subscriptions =
    Blockstack.fileSaved (\value -> ProjectSaved value)


update : Msg -> Model -> Nav.Key -> ( Model, Cmd Msg )
update msg ( project, projects, seed ) navKey =
    case msg of
        SaveProject ->
            let
                ( projectToSave, newSeed ) =
                    setUuidIfEmpty project seed
            in
            ( ( { projectToSave | saving = True }, projects, newSeed ), Blockstack.putFile (parseProjectToFile projectToSave) )

        ProjectSaved savedProjectFile ->
            let
                savedProject =
                    parseFileToProject savedProjectFile

                updatedProjects =
                    reconcileProjects projects savedProject
            in
            ( ( emptyProject, updatedProjects, seed ), redirectToProjectList navKey )

        ChangeDescription newDescription ->
            ( ( { project | description = newDescription, isSaved = False }, projects, seed ), Cmd.none )

        ChangeTitle newTitle ->
            ( ( { project | title = newTitle, isSaved = False }, projects, seed ), Cmd.none )

        ChangeGoal maybeNewGoal ->
            let
                newGoal =
                    case String.toFloat maybeNewGoal of
                        Just goal ->
                            goal

                        Nothing ->
                            0.0
            in
            ( ( { project | goal = newGoal, isSaved = False }, projects, seed ), Cmd.none )


createProjectRoute : String
createProjectRoute =
    Url.Builder.absolute [ "projects", "new" ] []


createProjectTitle : String
createProjectTitle =
    "Create your new descentralized crowdfunding project - Blocos"


buttonLabel : Bool -> String
buttonLabel isSaving =
    if isSaving == True then
        "Saving..."

    else
        "Save"


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
        [ Html.h1 [ Attributes.class "title" ] [ Html.text "Create your new project" ]
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
                , Attributes.disabled currentProject.saving
                , Attributes.value <| buttonLabel currentProject.saving
                ]
                []
            ]
        ]
