module Page.CreateProject exposing (Msg, route, title, view)

import Browser
import Html exposing (Html, button, p, section, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
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


view : Session.User -> Html Msg
view user =
    let
        username =
            case user of
                ( Session.LoggedIn, Just userData ) ->
                    userData.username

                _ ->
                    "Anonymous"
    in
    section []
        [ p [ class "text" ] [ text "Create your new project" ]
        ]
