module Page.Home exposing (route, title, view)

import Browser
import Html exposing (Html, button, p, section, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Json.Encode as Encode exposing (..)
import Session


route : String
route =
    "/"


title : String
title =
    "Blocos - Descentralized Crowdfunding"


view : Session.User -> Html Session.Msg
view user =
    let
        username =
            case user of
                ( Session.LoggedIn, Just userData ) ->
                    userData.username

                _ ->
                    "Anonymous"
    in
    section [ class "home content" ]
        [ p [ class "text" ] [ text "Blocos is a descentralized crowdfunding platform " ]
        , p [ class "text" ] [ text "It's goal is to enable true peer-to-peer financial cooperation" ]
        , p [ class "text" ] [ text "It allows for global transactions" ]
        , p [ class "text" ] [ text "It's uncensored" ]
        , button [ class "button", onClick Session.SignIn ] [ text "sign in using blockstack" ]
        ]
