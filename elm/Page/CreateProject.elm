module Page.CreateProject exposing (Msg, emptyProject, route, title, view)

import Browser
import Html
import Html.Attributes as Attributes
import Html.Events as Events
import Json.Encode as Encode exposing (..)
import Session
import Url.Builder


route : String
route =
    Url.Builder.absolute [ "projects", "new" ] []


title : String
title =
    "Create your new descentralized crowdfunding project - Blocos"


type Msg
    = Nothing


type alias Project =
    { title : String
    , description : String
    , imageUri : String
    }


emptyProject : Project
emptyProject =
    { title = "", description = "", imageUri = "" }


view : Session.User -> Project -> Html.Html Msg
view user project =
    let
        username =
            case user of
                ( Session.LoggedIn, Just userData ) ->
                    userData.username

                _ ->
                    "Anonymous"
    in
    Html.section []
        [ Html.p [ Attributes.class "text" ] [ Html.text "Create your new project" ]
        , Html.form [ Attributes.class "form form-project", Attributes.action "#" ]
            [ Html.input [ Attributes.class "input", Attributes.type_ "text", Attributes.value project.description, Attributes.placeholder "Project title" ] []
            , Html.textarea [ Attributes.class "textarea" ] [ Html.text project.description ]
            , Html.input [ Attributes.class "submit", Attributes.type_ "submit", Attributes.value "Save" ] []
            ]
        ]
