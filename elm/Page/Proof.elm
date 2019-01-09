module Page.Proof exposing (Model, Msg, route, title, view)

import Html exposing (Html, a, button, footer, h1, header, i, main_, p, section, strong, text)
import Html.Attributes exposing (class, href, target)


type alias Model =
    String


type Msg
    = Nothing


route : String
route =
    "proof-of-running-code"


title : String
title =
    "Blocos - Proof of running code"



-- view : Html
-- @TODO: Automate the whole release checksum generation and display


view : Model -> Html a
view model =
    section [ class "content" ]
        [ p [] [ h1 [] [ text "Proof of running code" ] ]
        , p [] [ strong [] [ i [] [ text "07wFbyetxuSrHYFYdF6tKVluAVE92qscSq5ZPJ19WGg=" ] ] ]
        , p [] [ a [ target "_blank", href "https://github.com/blocosapp/blocos/releases" ] [ text "check current release checksum" ] ]
        , p [] [ p [] [ text "Blocos aims to be a tool for allowing as much as possible true peer-to-peer crowd funding. Accomplishing such a task in a web environment is an utterly complex task, because of all the layers of abstractions involved." ] ]
        , p []
            [ text "As a platform, Blocos sits on top of multiple open protocols and platforms such as "
            , a [ target "_blank", href "https://bitcoin.org" ] [ text "bitcoin" ]
            , text " and "
            , a [ target "_blank", href "https://blockstack.com" ] [ text "blockstack" ]
            , text ". A core aspect of the openess of those protocols and of Blocos itself is that all of them are open-source. The source code used to run those applications is free for everyone to see, and hence, be sure of what is happening when you're running that code."
            , text "Blocos, and other new web applications are bringing this concept to the forefront of the web environment. Blocos, as a whole is open source, and you can check it's code "
            , a [ target "_blank", href "https://github.com/blocosapp/blocos" ] [ text "here" ]
            , text ". But this raises a question: how do I know that the code I'm checking is the code currently running on this webpage?"
            ]
        , p []
            [ text "Though this is a really small bit of garanteeing that you don't have any third-party subject interfering somehow with what you're doing on a website, this an essential bit of transparently sharing the code. Making sure that the shared code is the currently running one." ]
        , p []
            [ text "To garantee this on Blocos, we use the integrity attribute of the code running on the application. With "
            , a [ target "_blank", href "https://github.com/blocosapp/blocos/releases" ] [ text "every release" ]
            , text " of our application we publish a SHA256 hash that corresponds to the cryptographic digest of the main application file. On the repository you also get instructions of how to generate the hash and the application file itself, so you have all the tools to check by yourself the integrity of the code currently running on the website."
            ]
        , p [] [ text "Current checksum is: " ]
        , p [] [ i [] [ text "07wFbyetxuSrHYFYdF6tKVluAVE92qscSq5ZPJ19WGg=" ] ]
        , p []
            [ text "Check what "
            , a [ target "_blank", href "https://github.com/blocosapp/blocos/releases" ] [ text "the current release should be" ]
            , text "."
            ]
        ]
