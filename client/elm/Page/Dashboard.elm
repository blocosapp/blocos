module Page.Dashboard exposing (Msg, projectRoot, route, title, view)

import Browser
import Html
import Html.Attributes as Attributes
import Html.Events exposing (onClick)
import Json.Encode as Encode exposing (..)
import List
import Project
import Session
import Url.Builder


route : String
route =
    "dashboard"


projectRoot : String
projectRoot =
    "projects"


title : String
title =
    "Blocos app"


type Msg
    = Nothing


view : Session.User -> Project.Model -> Html.Html Msg
view user ( project, projects, _ ) =
    let
        username =
            case user of
                ( Session.LoggedIn, Just userData ) ->
                    userData.username

                _ ->
                    "Anonymous"
    in
    Html.section [ Attributes.class "home content" ]
        [ Html.p [ Attributes.class "text" ] [ Html.text username ]
        , Html.a [ Attributes.class "link", Attributes.href <| Project.createProjectRoute ] [ Html.text "+ create new project" ]
        , Html.h2 [ Attributes.class "subtitle" ] [ Html.text "Drafts" ]
        , Html.div [] (List.map (\projectItem -> Html.a [ Attributes.class "link" ] [ Html.text projectItem.description ]) projects)
        ]
