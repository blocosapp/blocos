module Project exposing
    ( Model
    , Msg(..)
    , Project
    , ProjectStatus(..)
    , createProjectRoute
    , createProjectTitle
    , createProjectView
    , editProjectTitle
    , emptyProject
    , getEditProjectRoute
    , publishProjectView
    , setCurrentProjectByUuidString
    , subscriptions
    , update
    )

import Browser.Navigation as Nav
import File exposing (File)
import File.Select as Select
import Html
import Html.Attributes as Attributes
import Html.Events as Events
import List
import Port.Blockstack as Blockstack
import Prng.Uuid as Uuid
import Random.Pcg.Extended as Random
import Session
import String
import Svg
import Svg.Attributes
import Task
import Url.Builder


type ProjectStatus
    = Unsaved
    | Saving
    | Saved
    | Publishing
    | Published


type alias WalletAddress =
    String


type alias Reward =
    { id : Int, title : String, contribution : Float, description : String }


type alias Project =
    { uuid : Maybe Uuid.Uuid
    , address : Maybe WalletAddress
    , cardImageUrl : String
    , coverImageUrl : String
    , description : String
    , duration : Int
    , goal : Float
    , projectVideoUrl : String
    , rewards : List Reward
    , status : ProjectStatus
    , tagline : String
    , title : String
    }


type alias Model =
    ( Project, List Project, Random.Seed )


emptyProject : Project
emptyProject =
    { uuid = Nothing
    , address = Nothing
    , cardImageUrl = ""
    , coverImageUrl = ""
    , description = ""
    , duration = 60
    , goal = 0.0
    , projectVideoUrl = ""
    , rewards = []
    , status = Saved
    , tagline = ""
    , title = ""
    }


type Msg
    = AddReward
    | CardImageSelected File
    | ChangeAddress String
    | ChangeCardImage
    | ChangeCoverImage
    | ChangeDescription String
    | ChangeDuration String
    | ChangeGoal String
    | ChangeProjectVideo String
    | ChangeRewardContribution Reward String
    | ChangeRewardDescription Reward String
    | ChangeRewardTitle Reward String
    | ChangeTagline String
    | ChangeTitle String
    | DeleteProject
    | CoverImageSelected File
    | DeleteCardImage
    | DeleteCoverImage
    | DeleteReward Reward
    | EditProject Project
    | GetCardImageFile String
    | GetCoverImageFile String
    | ProjectDeleted
    | ProjectSaved Blockstack.ProjectFile
    | PublishProject
    | SaveProject


cameraIcon : Svg.Svg msg
cameraIcon =
    Svg.svg [ Svg.Attributes.width "24", Svg.Attributes.height "20", Svg.Attributes.viewBox "0 0 24 20", Svg.Attributes.fill "none" ] [ Svg.path [ Svg.Attributes.fillRule "evenodd", Svg.Attributes.clipRule "evenodd", Svg.Attributes.d "M8.16795 0.4453C8.35342 0.167101 8.66565 0 9 0H15C15.3344 0 15.6466 0.167101 15.8321 0.4453L17.5352 3H21C21.7957 3 22.5587 3.31607 23.1213 3.87868C23.6839 4.44129 24 5.20435 24 6V17C24 17.7957 23.6839 18.5587 23.1213 19.1213C22.5587 19.6839 21.7957 20 21 20H3C2.20435 20 1.44129 19.6839 0.87868 19.1213C0.316071 18.5587 0 17.7957 0 17V6C0 5.20435 0.316071 4.44129 0.87868 3.87868C1.44129 3.31607 2.20435 3 3 3H6.46482L8.16795 0.4453ZM9.53518 2L7.83205 4.5547C7.64658 4.8329 7.33435 5 7 5H3C2.73478 5 2.48043 5.10536 2.29289 5.29289C2.10536 5.48043 2 5.73478 2 6V17C2 17.2652 2.10536 17.5196 2.29289 17.7071C2.48043 17.8946 2.73478 18 3 18H21C21.2652 18 21.5196 17.8946 21.7071 17.7071C21.8946 17.5196 22 17.2652 22 17V6C22 5.73478 21.8946 5.48043 21.7071 5.29289C21.5196 5.10536 21.2652 5 21 5H17C16.6656 5 16.3534 4.8329 16.1679 4.5547L14.4648 2H9.53518Z", Svg.Attributes.fill "black" ] [], Svg.path [ Svg.Attributes.fillRule "evenodd", Svg.Attributes.clipRule "evenodd", Svg.Attributes.d "M12 8C10.3431 8 9 9.34315 9 11C9 12.6569 10.3431 14 12 14C13.6569 14 15 12.6569 15 11C15 9.34315 13.6569 8 12 8ZM7 11C7 8.23858 9.23858 6 12 6C14.7614 6 17 8.23858 17 11C17 13.7614 14.7614 16 12 16C9.23858 16 7 13.7614 7 11Z", Svg.Attributes.fill "black" ] [] ]


pencilIcon : Svg.Svg msg
pencilIcon =
    Svg.svg [ Svg.Attributes.width "20", Svg.Attributes.height "20", Svg.Attributes.viewBox "0 0 20 20", Svg.Attributes.fill "none" ] [ Svg.path [ Svg.Attributes.fillRule "evenodd", Svg.Attributes.clipRule "evenodd", Svg.Attributes.d "M13.2929 0.292893C13.6834 -0.0976311 14.3166 -0.0976311 14.7071 0.292893L19.7071 5.29289C20.0976 5.68342 20.0976 6.31658 19.7071 6.70711L6.70711 19.7071C6.51957 19.8946 6.26522 20 6 20H1C0.447715 20 0 19.5523 0 19V14C0 13.7348 0.105357 13.4804 0.292893 13.2929L13.2929 0.292893ZM2 14.4142V18H5.58579L17.5858 6L14 2.41421L2 14.4142Z", Svg.Attributes.fill "black" ] [] ]


trashIcon : Svg.Svg msg
trashIcon =
    Svg.svg [ Svg.Attributes.width "20", Svg.Attributes.height "22", Svg.Attributes.viewBox "0 0 20 22", Svg.Attributes.fill "none" ] [ Svg.path [ Svg.Attributes.fillRule "evenodd", Svg.Attributes.clipRule "evenodd", Svg.Attributes.d "M0 5C0 4.44772 0.447715 4 1 4H19C19.5523 4 20 4.44772 20 5C20 5.55228 19.5523 6 19 6H1C0.447715 6 0 5.55228 0 5Z", Svg.Attributes.fill "black" ] [], Svg.path [ Svg.Attributes.fillRule "evenodd", Svg.Attributes.clipRule "evenodd", Svg.Attributes.d "M8 2C7.73478 2 7.48043 2.10536 7.29289 2.29289C7.10536 2.48043 7 2.73478 7 3V4H13V3C13 2.73478 12.8946 2.48043 12.7071 2.29289C12.5196 2.10536 12.2652 2 12 2H8ZM15 4V3C15 2.20435 14.6839 1.44129 14.1213 0.87868C13.5587 0.31607 12.7956 0 12 0H8C7.20435 0 6.44129 0.31607 5.87868 0.87868C5.31607 1.44129 5 2.20435 5 3V4H3C2.44772 4 2 4.44772 2 5V19C2 19.7957 2.31607 20.5587 2.87868 21.1213C3.44129 21.6839 4.20435 22 5 22H15C15.7957 22 16.5587 21.6839 17.1213 21.1213C17.6839 20.5587 18 19.7957 18 19V5C18 4.44772 17.5523 4 17 4H15ZM4 6V19C4 19.2652 4.10536 19.5196 4.29289 19.7071C4.48043 19.8946 4.73478 20 5 20H15C15.2652 20 15.5196 19.8946 15.7071 19.7071C15.8946 19.5196 16 19.2652 16 19V6H4Z", Svg.Attributes.fill "black" ] [], Svg.path [ Svg.Attributes.fillRule "evenodd", Svg.Attributes.clipRule "evenodd", Svg.Attributes.d "M8 9C8.55228 9 9 9.44771 9 10V16C9 16.5523 8.55228 17 8 17C7.44772 17 7 16.5523 7 16V10C7 9.44771 7.44772 9 8 9Z", Svg.Attributes.fill "black" ] [], Svg.path [ Svg.Attributes.fillRule "evenodd", Svg.Attributes.clipRule "evenodd", Svg.Attributes.d "M12 9C12.5523 9 13 9.44771 13 10V16C13 16.5523 12.5523 17 12 17C11.4477 17 11 16.5523 11 16V10C11 9.44771 11.4477 9 12 9Z", Svg.Attributes.fill "black" ] [] ]


maxNumberOfRewards : Int
maxNumberOfRewards =
    7


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
    { uuid = uuidString
    , address = project.address
    , cardImageUrl = project.cardImageUrl
    , coverImageUrl = project.coverImageUrl
    , description = project.description
    , duration = project.duration
    , goal = project.goal
    , projectVideoUrl = project.projectVideoUrl
    , rewards = project.rewards
    , tagline = project.tagline
    , title = project.title
    }


parseFileToProject : Blockstack.ProjectFile -> Project
parseFileToProject projectFile =
    { uuid = Uuid.fromString projectFile.uuid
    , address = projectFile.address
    , cardImageUrl = projectFile.cardImageUrl
    , coverImageUrl = projectFile.coverImageUrl
    , description = projectFile.description
    , duration = projectFile.duration
    , goal = projectFile.goal
    , projectVideoUrl = projectFile.projectVideoUrl
    , rewards = projectFile.rewards
    , status = Saved
    , tagline = projectFile.tagline
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


removeProject : List Project -> Project -> List Project
removeProject projects project =
    List.filter (\item -> item.uuid /= project.uuid) projects


getEditProjectRoute : Project -> String
getEditProjectRoute project =
    case project.uuid of
        Just uuid ->
            Url.Builder.absolute [ "projects", "edit", Uuid.toString uuid ] []

        Nothing ->
            Url.Builder.absolute [ "projects", "new" ] []


getPublishProjectRoute : Uuid.Uuid -> String
getPublishProjectRoute uuid =
    Url.Builder.absolute [ "projects", "publish", Uuid.toString uuid ] []


setCurrentProjectByUuidString : String -> Model -> Model
setCurrentProjectByUuidString uuidString ( _, projects, seed ) =
    let
        parsedUuid =
            Uuid.fromString uuidString

        getProject projectUuid =
            Maybe.withDefault emptyProject (List.head <| List.filter (\project -> project.uuid == projectUuid) projects)
    in
    case parsedUuid of
        Just uuid ->
            ( getProject parsedUuid, projects, seed )

        Nothing ->
            ( emptyProject, projects, seed )


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


redirectTo : String -> Nav.Key -> Cmd Msg
redirectTo urlString navKey =
    Nav.pushUrl navKey urlString


projectListUrl : String
projectListUrl =
    Url.Builder.absolute [ "dashboard" ] []


rewardTabUrl : String
rewardTabUrl =
    Url.Builder.absolute [ "project", "reward" ] []


redirectToEditPage : Project -> Nav.Key -> Cmd Msg
redirectToEditPage project navKey =
    Nav.pushUrl navKey (getEditProjectRoute project)


subscriptions : Sub Msg
subscriptions =
    Sub.batch
        [ Blockstack.fileSaved (\value -> ProjectSaved value)
        , Blockstack.fileDeleted (\_ -> ProjectDeleted)
        ]


selectImage : (File -> msg) -> Cmd msg
selectImage cmd =
    Select.file [ "image/png", "image/jpg", "image/jpeg", "image/gif" ] cmd


updateRewardsIndex : List Reward -> List Reward
updateRewardsIndex rewards =
    List.indexedMap (\index reward -> { reward | id = index + 1 }) rewards


update : Msg -> Model -> Nav.Key -> ( Model, Cmd Msg )
update msg ( project, projects, seed ) navKey =
    let
        currentModel =
            ( project, projects, seed )
    in
    case msg of
        DeleteProject ->
            let
                updatedProjects =
                    removeProject projects project
            in
            ( ( project, updatedProjects, seed ), Blockstack.deleteFile (parseProjectToFile project) )

        SaveProject ->
            let
                ( projectToSave, newSeed ) =
                    setUuidIfEmpty project seed
            in
            ( ( { projectToSave | status = Saving }, projects, newSeed ), Blockstack.putFile (parseProjectToFile projectToSave) )

        ProjectSaved savedProjectFile ->
            let
                savedProject =
                    parseFileToProject savedProjectFile

                updatedProjects =
                    reconcileProjects projects savedProject

                currentProject =
                    if savedProject.uuid == project.uuid then
                        savedProject

                    else
                        project
            in
            ( ( currentProject, updatedProjects, seed ), Cmd.none )

        ProjectDeleted ->
            ( ( emptyProject, projects, seed ), redirectTo projectListUrl navKey )

        EditProject projectToEdit ->
            ( ( projectToEdit, projects, seed ), Cmd.none )

        ChangeDescription newDescription ->
            ( ( { project | description = newDescription, status = Unsaved }, projects, seed ), Cmd.none )

        ChangeTitle newTitle ->
            ( ( { project | title = newTitle, status = Unsaved }, projects, seed ), Cmd.none )

        ChangeTagline newTagline ->
            ( ( { project | tagline = newTagline, status = Unsaved }, projects, seed ), Cmd.none )

        CardImageSelected file ->
            ( currentModel, Task.perform GetCardImageFile (File.toUrl file) )

        ChangeCardImage ->
            ( currentModel, selectImage CardImageSelected )

        GetCardImageFile newCardImageUrl ->
            ( ( { project | cardImageUrl = newCardImageUrl }, projects, seed ), Cmd.none )

        DeleteCardImage ->
            ( ( { project | cardImageUrl = "" }, projects, seed ), Cmd.none )

        ChangeCoverImage ->
            ( currentModel, selectImage CoverImageSelected )

        CoverImageSelected file ->
            ( currentModel, Task.perform GetCoverImageFile (File.toUrl file) )

        GetCoverImageFile newCoverImageUrl ->
            ( ( { project | coverImageUrl = newCoverImageUrl }, projects, seed ), Cmd.none )

        ChangeDuration duration ->
            let
                projectDuration =
                    Maybe.withDefault 0 <| String.toInt duration
            in
            ( ( { project | duration = projectDuration }, projects, seed ), Cmd.none )

        DeleteCoverImage ->
            ( ( { project | coverImageUrl = "" }, projects, seed ), Cmd.none )

        ChangeProjectVideo newProjectVideoUrl ->
            ( ( { project | projectVideoUrl = newProjectVideoUrl, status = Unsaved }, projects, seed ), Cmd.none )

        AddReward ->
            let
                emptyReward =
                    { id = List.length project.rewards + 1, title = "", description = "", contribution = 0 }

                rewards =
                    if List.length project.rewards >= maxNumberOfRewards then
                        project.rewards

                    else
                        updateRewardsIndex <| project.rewards ++ [ emptyReward ]
            in
            ( ( { project | rewards = rewards }, projects, seed ), Cmd.none )

        DeleteReward reward ->
            let
                updatedRewards =
                    updateRewardsIndex <| List.filter (\rewardItem -> reward.id /= rewardItem.id) project.rewards
            in
            ( ( { project | rewards = updatedRewards }, projects, seed ), Cmd.none )

        ChangeRewardTitle rewardToUpdate title ->
            let
                updateReward reward =
                    if rewardToUpdate.id == reward.id then
                        { reward | title = title }

                    else
                        reward

                rewards =
                    List.map updateReward project.rewards
            in
            ( ( { project | rewards = rewards }, projects, seed ), Cmd.none )

        ChangeRewardContribution rewardToUpdate maybeContribution ->
            let
                contribution =
                    case String.toFloat maybeContribution of
                        Just value ->
                            value

                        Nothing ->
                            0

                updateReward reward =
                    if rewardToUpdate.id == reward.id then
                        { reward | contribution = contribution }

                    else
                        reward

                rewards =
                    List.map updateReward project.rewards
            in
            ( ( { project | rewards = rewards }, projects, seed ), Cmd.none )

        ChangeRewardDescription rewardToUpdate description ->
            let
                updateReward reward =
                    if rewardToUpdate.id == reward.id then
                        { reward | description = description }

                    else
                        reward

                rewards =
                    List.map updateReward project.rewards
            in
            ( ( { project | rewards = rewards }, projects, seed ), Cmd.none )

        ChangeGoal maybeNewGoal ->
            let
                newGoal =
                    case String.toFloat maybeNewGoal of
                        Just goal ->
                            goal

                        Nothing ->
                            0.0
            in
            ( ( { project | goal = newGoal, status = Unsaved }, projects, seed ), Cmd.none )

        ChangeAddress address ->
            ( ( { project | address = Just address, status = Unsaved }, projects, seed ), Cmd.none )

        PublishProject ->
            ( currentModel, Cmd.none )


createProjectRoute : String
createProjectRoute =
    Url.Builder.absolute [ "projects", "new" ] []


createProjectTitle : String
createProjectTitle =
    "Create your new decentralized crowdfunding project - Blocos"


editProjectTitle : String
editProjectTitle =
    "Edit project - Blocos"


saveButtonLabel : ProjectStatus -> String
saveButtonLabel status =
    case status of
        Saving ->
            "Saving..."

        Saved ->
            "Saved"

        Unsaved ->
            "Save"

        _ ->
            "..."


publishButtonLabel : ProjectStatus -> String
publishButtonLabel status =
    case status of
        Publishing ->
            "Publishing..."

        _ ->
            "Publish project"


type ImageSize
    = Card
    | Cover


renderImageSelector : String -> ImageSize -> Msg -> Msg -> Html.Html Msg
renderImageSelector imageUrl imageSize changeImageCmd deleteImageCmd =
    let
        ( selectorText, selectorClass ) =
            case imageSize of
                Card ->
                    ( "recommended size 320x320px", "-card" )

                Cover ->
                    ( "recommended size 1024x633px", "-cover" )
    in
    if imageUrl == "" then
        Html.div
            [ Attributes.class "image-selector"
            , Events.onClick changeImageCmd
            ]
            [ Html.input
                [ Attributes.class "image-selector__input"
                , Attributes.type_ "file"
                ]
                []
            , Html.div [ Attributes.class <| "image-selector__selector " ++ selectorClass ]
                [ Html.p [ Attributes.class "image-selector__icon" ] [ cameraIcon ]
                , Html.p [ Attributes.class "image-selector__text" ] [ Html.text "choose an image" ]
                , Html.p [ Attributes.class "image-selector__text" ] [ Html.text selectorText ]
                ]
            ]

    else
        Html.div [ Attributes.class <| "image-selector -preview " ++ selectorClass, Attributes.style "background-image" ("url(" ++ imageUrl ++ ")") ]
            [ Html.div [ Attributes.class "image-selector__actions" ]
                [ Html.button [ Attributes.class "image-selector__actionButton", Attributes.type_ "button", Events.onClick changeImageCmd ]
                    [ pencilIcon ]
                , Html.button [ Attributes.class "image-selector__actionButton", Attributes.type_ "button", Events.onClick deleteImageCmd ]
                    [ trashIcon ]
                ]
            ]


createProjectView : Session.User -> Model -> Html.Html Msg
createProjectView user ( currentProject, _, _ ) =
    let
        username =
            case user of
                ( Session.LoggedIn, Just userData ) ->
                    userData.username

                _ ->
                    "Anonymous"

        hasTaskInProgress =
            case currentProject.status of
                Saving ->
                    True

                _ ->
                    False

        renderReward reward =
            Html.li [ Attributes.class "rewards-list__item" ]
                [ Html.div [ Attributes.class "rewards-list__item-wrapper" ]
                    [ Html.h3 [ Attributes.class "rewards-list__title" ] [ Html.text ("#" ++ String.fromInt reward.id) ]
                    , Html.input
                        [ Attributes.class "rewards-list__reward -text"
                        , Attributes.type_ "text"
                        , Attributes.value reward.title
                        , Attributes.placeholder "Add your reward title"
                        , Events.onInput <| ChangeRewardTitle reward
                        ]
                        []
                    , Html.textarea
                        [ Attributes.class "rewards-list__reward -textarea"
                        , Attributes.placeholder "Describe what this reward is about"
                        , Attributes.value reward.description
                        , Events.onInput <| ChangeRewardDescription reward
                        ]
                        []
                    , Html.span [ Attributes.class "amount-with-unit" ]
                        [ Html.input
                            [ Attributes.class "amount-with-unit__amount rewards-list__reward -number"
                            , Attributes.placeholder "5000"
                            , Attributes.type_ "number"
                            , Attributes.value <| String.fromFloat reward.contribution
                            , Events.onInput <| ChangeRewardContribution reward
                            ]
                            []
                        , Html.span [ Attributes.class "amount-with-unit__unit" ] [ Html.text "Satoshis" ]
                        ]
                    , Html.button [ Attributes.type_ "button", Attributes.class "button -inverted -alert rewards-list__delete", Events.onClick <| DeleteReward reward ] [ Html.text "Delete" ]
                    , Html.hr [ Attributes.class "rewards-list__divider" ] []
                    ]
                ]

        rewardsList =
            List.map renderReward currentProject.rewards

        renderAddRewardsButton rewards =
            if List.length rewards >= maxNumberOfRewards then
                Html.p [ Attributes.class "form-message" ] [ Html.text "You can't add more rewards" ]

            else
                Html.button
                    [ Attributes.class "button -form -inverted"
                    , Attributes.type_ "button"
                    , Events.onClick AddReward
                    ]
                    [ Html.text "+ add reward" ]

        renderPublishButton =
            case currentProject.uuid of
                Just uuid ->
                    Html.a
                        [ Attributes.class "button -primary project-actions__submit"
                        , Attributes.href <| getPublishProjectRoute uuid
                        ]
                        [ Html.text <| publishButtonLabel currentProject.status ]

                Nothing ->
                    Html.div [] []
    in
    Html.section [ Attributes.class "create-project" ]
        [ Html.h1 [ Attributes.class "title" ] [ Html.text "Project Information" ]
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
                , Html.span [ Attributes.class "label-support" ] [ Html.text "Your project title" ]
                , Html.input
                    [ Attributes.id "project-title"
                    , Attributes.class "input -text"
                    , Attributes.type_ "text"
                    , Attributes.value currentProject.title
                    , Attributes.placeholder "BitWallet - the best BTC wallet"
                    , Events.onInput ChangeTitle
                    ]
                    []
                ]
            , Html.fieldset
                [ Attributes.class "fieldset" ]
                [ Html.label
                    [ Attributes.class "label"
                    , Attributes.for "project-tagline"
                    ]
                    [ Html.text "Tagline" ]
                , Html.span [ Attributes.class "label-support" ] [ Html.text "A short description of your project" ]
                , Html.input
                    [ Attributes.id "project-tagline"
                    , Attributes.class "input -text"
                    , Attributes.type_ "text"
                    , Attributes.value currentProject.tagline
                    , Attributes.placeholder "A bitcoin wallet & card accessible for everyone"
                    , Events.onInput ChangeTagline
                    ]
                    []
                ]
            , Html.fieldset
                [ Attributes.class "fieldset" ]
                [ Html.span [ Attributes.class "label-support" ] [ Html.text "The image shown when your project is shown on a list" ]
                , Html.label
                    [ Attributes.class "label"
                    , Attributes.for "project-card-image"
                    ]
                    [ Html.text "Card image" ]
                , renderImageSelector currentProject.cardImageUrl Card ChangeCardImage DeleteCardImage
                ]
            , Html.fieldset
                [ Attributes.class "fieldset" ]
                [ Html.span [ Attributes.class "label-support" ] [ Html.text "The image that goes on your project details page" ]
                , Html.label
                    [ Attributes.class "label"
                    , Attributes.for "project-cover-image"
                    ]
                    [ Html.text "Cover image" ]
                , renderImageSelector currentProject.coverImageUrl Cover ChangeCoverImage DeleteCoverImage
                ]
            , Html.fieldset
                [ Attributes.class "fieldset" ]
                [ Html.label
                    [ Attributes.class "label"
                    , Attributes.for "project-pitch-video"
                    ]
                    [ Html.text "Project video" ]
                , Html.span [ Attributes.class "label-support" ] [ Html.text "Remember: one image says more than a thousand words." ]
                , Html.input
                    [ Attributes.id "project-pitch-video"
                    , Attributes.class "input -text"
                    , Attributes.type_ "text"
                    , Attributes.placeholder "https://www.youtube.com/watch?v=I2O7blSSzpI"
                    , Events.onInput ChangeProjectVideo
                    ]
                    []
                ]
            , Html.fieldset
                [ Attributes.class "fieldset" ]
                [ Html.label
                    [ Attributes.class "label"
                    , Attributes.for "project-rewards"
                    ]
                    [ Html.text "Project rewards" ]
                , Html.span [ Attributes.class "label-support" ] [ Html.text "Provide incentive for your community to support you." ]
                , Html.ul [ Attributes.class "rewards-list" ] rewardsList
                , renderAddRewardsButton currentProject.rewards
                ]
            , Html.fieldset
                [ Attributes.class "fieldset" ]
                [ Html.label
                    [ Attributes.class "label"
                    , Attributes.for "project-description"
                    ]
                    [ Html.text "Description" ]
                , Html.span [ Attributes.class "label-support" ] [ Html.text "This is the space to tell everyone about your project story." ]
                , Html.textarea
                    [ Attributes.class "input -textarea"
                    , Attributes.name "project-description"
                    , Attributes.placeholder "This is the start of a mission: allow every citizen connected to the internet to own bitcoin."
                    , Events.onInput ChangeDescription
                    ]
                    [ Html.text currentProject.description ]
                ]
            , Html.div [ Attributes.class "project-actions" ]
                [ Html.input
                    [ Attributes.class "button -alert -delete project-actions__action"
                    , Attributes.type_ "button"
                    , Attributes.disabled hasTaskInProgress
                    , Attributes.value "Delete"
                    , Events.onClick DeleteProject
                    ]
                    []
                , Html.input
                    [ Attributes.class "button -inverted -save project-actions__action"
                    , Attributes.type_ "submit"
                    , Attributes.disabled hasTaskInProgress
                    , Attributes.value <| saveButtonLabel currentProject.status
                    ]
                    []
                , renderPublishButton
                ]
            ]
        ]


publishProjectView : Session.User -> Model -> Html.Html Msg
publishProjectView user ( currentProject, _, _ ) =
    let
        username =
            case user of
                ( Session.LoggedIn, Just userData ) ->
                    userData.username

                _ ->
                    "Anonymous"

        walletAddress =
            case currentProject.address of
                Just address ->
                    address

                Nothing ->
                    ""

        projectDuration =
            String.fromInt currentProject.duration

        hasTaskInProgress =
            case currentProject.status of
                Publishing ->
                    True

                _ ->
                    False
    in
    Html.section [ Attributes.class "publish-project" ]
        [ Html.h1 [ Attributes.class "publish-project__title" ] [ Html.text "Publish your project" ]
        , Html.p [ Attributes.class "info" ] [ Html.text "When publishing a project, the information related to it is going to be persisted to a blockchain. After that, you can no longer edit the project main information." ]
        , Html.h2 [ Attributes.class "publish-project__project-title" ] [ Html.text currentProject.title ]
        , Html.form
            [ Attributes.class "publish-project__form"
            , Attributes.name "publish-project"
            , Attributes.action "#"
            , Events.onSubmit PublishProject
            ]
            [ Html.fieldset
                [ Attributes.class "fieldset" ]
                [ Html.label
                    [ Attributes.class "label"
                    , Attributes.for "project-wallet"
                    ]
                    [ Html.text "Project wallet address" ]
                , Html.span [ Attributes.class "label-support" ] [ Html.text "The wallet address that is going to receive the project's funded money." ]
                , Html.input [ Attributes.class "input -text", Attributes.name "project-wallet", Attributes.placeholder "1BvBMSEYstWetqTFn5Au4m4GFg7xJaNVN2", Events.onInput ChangeAddress, Attributes.value walletAddress ] []
                ]
            , Html.fieldset
                [ Attributes.class "fieldset" ]
                [ Html.label
                    [ Attributes.class "label"
                    , Attributes.for "project-days"
                    ]
                    [ Html.text "Funding duration" ]
                , Html.span [ Attributes.class "label-support" ] [ Html.text "How many days you expect to run the project. Max. 60 days." ]
                , Html.input
                    [ Attributes.class "input -text -short"
                    , Attributes.name "project-days"
                    , Attributes.placeholder "60"
                    , Attributes.type_ "number"
                    , Attributes.max "60"
                    , Attributes.min "0"
                    , Events.onInput ChangeDuration
                    , Attributes.value projectDuration
                    ]
                    []
                ]
            , Html.div [ Attributes.class "project-actions" ]
                [ Html.a
                    [ Attributes.href <| getEditProjectRoute currentProject
                    , Attributes.class "button -inverted project-actions__action"
                    ]
                    [ Html.text "back to edit" ]
                , Html.input
                    [ Attributes.type_ "submit"
                    , Attributes.class "button -primary project-actions__action"
                    , Attributes.value "Publish project right now"
                    , Attributes.disabled hasTaskInProgress
                    ]
                    []
                ]
            ]
        ]
