module Page.Dashboard exposing (projectRoot, route, title, view)

import Browser
import Html
import Html.Attributes as Attributes
import Html.Events as Events
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


view : Session.User -> Project.Model -> Html.Html Project.Msg
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
        , Html.ul [ Attributes.class "projects-list" ]
            (List.map
                (\projectItem ->
                    Html.li [ Attributes.class "projecs-list projects-list__item" ]
                        [ Html.a
                            [ Attributes.class "project-link link"
                            , Attributes.href (Project.getEditProjectRoute projectItem)
                            , Events.onClick <| Project.EditProject projectItem
                            ]
                            [ Html.text projectItem.title ]
                        ]
                )
                projects
            )
        ]
