module Skeleton exposing (Model, Msg, SidebarStatus(..), application, content, update)

import Html
import Html.Attributes as Attributes
import Html.Events as Events
import Page.Dashboard as Dashboard
import Page.Home as Home
import Project
import Session
import Svg
import Svg.Attributes
import Url.Builder


type SidebarStatus
    = Opened
    | Closed


type alias Model =
    SidebarStatus


type Msg
    = ToggleMenu


update : Model -> Msg -> Model
update sidebarStatus _ =
    case sidebarStatus of
        Opened ->
            Closed

        Closed ->
            Opened


logo =
    Svg.svg [ Svg.Attributes.viewBox "212.318 198.922 351.66 64.99" ] [ Svg.path [ Svg.Attributes.d " M 219.008 252.242 L 220.57 252.242 L 220.57 213.082 L 219.008 213.082 L 219.008 213.082 Q 215.395 213.082 213.856 211.69 L 213.856 211.69 L 213.856 211.69 Q 212.318 210.299 212.318 208.053 L 212.318 208.053 L 212.318 208.053 Q 212.318 205.807 213.856 204.415 L 213.856 204.415 L 213.856 204.415 Q 215.395 203.023 219.008 203.023 L 219.008 203.023 L 244.105 203.023 L 244.105 203.023 Q 253.09 203.023 258.559 208.028 L 258.559 208.028 L 258.559 208.028 Q 264.027 213.033 264.027 219.918 L 264.027 219.918 L 264.027 219.918 Q 264.027 223.189 262.758 226.07 L 262.758 226.07 L 262.758 226.07 Q 261.488 228.951 258.9 231.393 L 258.9 231.393 L 258.9 231.393 Q 263.637 234.225 266.005 238.009 L 266.005 238.009 L 266.005 238.009 Q 268.373 241.793 268.373 246.578 L 268.373 246.578 L 268.373 246.578 Q 268.373 250.387 266.664 253.658 L 266.664 253.658 L 266.664 253.658 Q 265.395 256.148 263.539 257.613 L 263.539 257.613 L 263.539 257.613 Q 261.049 259.664 257.436 260.958 L 257.436 260.958 L 257.436 260.958 Q 253.822 262.252 248.402 262.252 L 248.402 262.252 L 219.008 262.252 L 219.008 262.252 Q 215.395 262.252 213.856 260.86 L 213.856 260.86 L 213.856 260.86 Q 212.318 259.469 212.318 257.223 L 212.318 257.223 L 212.318 257.223 Q 212.318 255.025 213.881 253.634 L 213.881 253.634 L 213.881 253.634 Q 215.443 252.242 219.008 252.242 L 219.008 252.242 L 219.008 252.242 Z  M 230.58 213.082 L 230.58 227.633 L 241.566 227.633 L 241.566 227.633 Q 247.475 227.633 251.381 224.654 L 251.381 224.654 L 251.381 224.654 Q 254.018 222.652 254.018 219.674 L 254.018 219.674 L 254.018 219.674 Q 254.018 217.037 251.527 215.06 L 251.527 215.06 L 251.527 215.06 Q 249.037 213.082 243.617 213.082 L 243.617 213.082 L 230.58 213.082 L 230.58 213.082 Z  M 230.58 237.643 L 230.58 252.242 L 247.865 252.242 L 247.865 252.242 Q 253.969 252.242 256.459 250.436 L 256.459 250.436 L 256.459 250.436 Q 258.363 249.068 258.363 246.529 L 258.363 246.529 L 258.363 246.529 Q 258.363 243.502 254.604 240.572 L 254.604 240.572 L 254.604 240.572 Q 250.844 237.643 243.813 237.643 L 243.813 237.643 L 230.58 237.643 L 230.58 237.643 Z  M 287.953 198.922 L 306.02 198.922 L 306.02 252.242 L 318.031 252.242 L 318.031 252.242 Q 321.645 252.242 323.183 253.634 L 323.183 253.634 L 323.183 253.634 Q 324.721 255.025 324.721 257.271 L 324.721 257.271 L 324.721 257.271 Q 324.721 259.469 323.183 260.86 L 323.183 260.86 L 323.183 260.86 Q 321.645 262.252 318.031 262.252 L 318.031 262.252 L 283.998 262.252 L 283.998 262.252 Q 280.385 262.252 278.847 260.86 L 278.847 260.86 L 278.847 260.86 Q 277.309 259.469 277.309 257.223 L 277.309 257.223 L 277.309 257.223 Q 277.309 255.025 278.847 253.634 L 278.847 253.634 L 278.847 253.634 Q 280.385 252.242 283.998 252.242 L 283.998 252.242 L 296.01 252.242 L 296.01 208.932 L 287.953 208.932 L 287.953 208.932 Q 284.389 208.932 282.826 207.54 L 282.826 207.54 L 282.826 207.54 Q 281.264 206.148 281.264 203.902 L 281.264 203.902 L 281.264 203.902 Q 281.264 201.705 282.802 200.313 L 282.802 200.313 L 282.802 200.313 Q 284.34 198.922 287.953 198.922 L 287.953 198.922 L 287.953 198.922 Z  M 387.025 240.914 L 387.025 240.914 L 387.025 240.914 Q 387.025 246.676 383.827 252.071 L 383.827 252.071 L 383.827 252.071 Q 380.629 257.467 374.306 260.665 L 374.306 260.665 L 374.306 260.665 Q 367.982 263.863 361.098 263.863 L 361.098 263.863 L 361.098 263.863 Q 354.262 263.863 348.012 260.714 L 348.012 260.714 L 348.012 260.714 Q 341.762 257.564 338.49 252.145 L 338.49 252.145 L 338.49 252.145 Q 335.219 246.725 335.219 240.816 L 335.219 240.816 L 335.219 240.816 Q 335.219 234.811 338.539 229.024 L 338.539 229.024 L 338.539 229.024 Q 341.859 223.238 348.085 219.918 L 348.085 219.918 L 348.085 219.918 Q 354.311 216.598 361.098 216.598 L 361.098 216.598 L 361.098 216.598 Q 367.934 216.598 374.257 219.991 L 374.257 219.991 L 374.257 219.991 Q 380.58 223.385 383.803 229.122 L 383.803 229.122 L 383.803 229.122 Q 387.025 234.859 387.025 240.914 Z  M 377.016 240.963 L 377.016 240.963 L 377.016 240.963 Q 377.016 236.129 373.549 232.076 L 373.549 232.076 L 373.549 232.076 Q 368.813 226.607 361.098 226.607 L 361.098 226.607 L 361.098 226.607 Q 354.311 226.607 349.77 230.953 L 349.77 230.953 L 349.77 230.953 Q 345.229 235.299 345.229 241.012 L 345.229 241.012 L 345.229 241.012 Q 345.229 245.699 349.818 249.776 L 349.818 249.776 L 349.818 249.776 Q 354.408 253.854 361.098 253.854 L 361.098 253.854 L 361.098 253.854 Q 367.836 253.854 372.426 249.776 L 372.426 249.776 L 372.426 249.776 Q 377.016 245.699 377.016 240.963 Z  M 436.635 219.723 L 436.635 219.723 L 436.635 219.723 Q 438.441 218.014 440.346 218.014 L 440.346 218.014 L 440.346 218.014 Q 442.494 218.014 443.886 219.552 L 443.886 219.552 L 443.886 219.552 Q 445.277 221.09 445.277 224.654 L 445.277 224.654 L 445.277 231.1 L 445.277 231.1 Q 445.277 234.713 443.886 236.227 L 443.886 236.227 L 443.886 236.227 Q 442.494 237.74 440.248 237.74 L 440.248 237.74 L 440.248 237.74 Q 438.197 237.74 436.781 236.568 L 436.781 236.568 L 436.781 236.568 Q 435.756 235.689 435.17 232.979 L 435.17 232.979 L 435.17 232.979 Q 434.584 230.27 432.338 228.951 L 432.338 228.951 L 432.338 228.951 Q 428.383 226.607 422.23 226.607 L 422.23 226.607 L 422.23 226.607 Q 415.15 226.607 410.878 230.758 L 410.878 230.758 L 410.878 230.758 Q 406.605 234.908 406.605 241.256 L 406.605 241.256 L 406.605 241.256 Q 406.605 247.115 410.707 250.509 L 410.707 250.509 L 410.707 250.509 Q 414.809 253.902 424.33 253.902 L 424.33 253.902 L 424.33 253.902 Q 430.58 253.902 434.535 252.633 L 434.535 252.633 L 434.535 252.633 Q 436.879 251.852 438.979 249.972 L 438.979 249.972 L 438.979 249.972 Q 441.078 248.092 442.787 248.092 L 442.787 248.092 L 442.787 248.092 Q 444.838 248.092 446.327 249.605 L 446.327 249.605 L 446.327 249.605 Q 447.816 251.119 447.816 253.17 L 447.816 253.17 L 447.816 253.17 Q 447.816 256.49 443.275 259.469 L 443.275 259.469 L 443.275 259.469 Q 436.537 263.912 423.549 263.912 L 423.549 263.912 L 423.549 263.912 Q 411.879 263.912 405.385 259.078 L 405.385 259.078 L 405.385 259.078 Q 396.596 252.584 396.596 241.305 L 396.596 241.305 L 396.596 241.305 Q 396.596 230.611 403.725 223.604 L 403.725 223.604 L 403.725 223.604 Q 410.854 216.598 422.328 216.598 L 422.328 216.598 L 422.328 216.598 Q 426.479 216.598 430.043 217.379 L 430.043 217.379 L 430.043 217.379 Q 433.607 218.16 436.635 219.723 Z  M 507.045 240.914 L 507.045 240.914 L 507.045 240.914 Q 507.045 246.676 503.847 252.071 L 503.847 252.071 L 503.847 252.071 Q 500.648 257.467 494.325 260.665 L 494.325 260.665 L 494.325 260.665 Q 488.002 263.863 481.117 263.863 L 481.117 263.863 L 481.117 263.863 Q 474.281 263.863 468.031 260.714 L 468.031 260.714 L 468.031 260.714 Q 461.781 257.564 458.51 252.145 L 458.51 252.145 L 458.51 252.145 Q 455.238 246.725 455.238 240.816 L 455.238 240.816 L 455.238 240.816 Q 455.238 234.811 458.559 229.024 L 458.559 229.024 L 458.559 229.024 Q 461.879 223.238 468.104 219.918 L 468.104 219.918 L 468.104 219.918 Q 474.33 216.598 481.117 216.598 L 481.117 216.598 L 481.117 216.598 Q 487.953 216.598 494.276 219.991 L 494.276 219.991 L 494.276 219.991 Q 500.6 223.385 503.822 229.122 L 503.822 229.122 L 503.822 229.122 Q 507.045 234.859 507.045 240.914 Z  M 497.035 240.963 L 497.035 240.963 L 497.035 240.963 Q 497.035 236.129 493.568 232.076 L 493.568 232.076 L 493.568 232.076 Q 488.832 226.607 481.117 226.607 L 481.117 226.607 L 481.117 226.607 Q 474.33 226.607 469.789 230.953 L 469.789 230.953 L 469.789 230.953 Q 465.248 235.299 465.248 241.012 L 465.248 241.012 L 465.248 241.012 Q 465.248 245.699 469.838 249.776 L 469.838 249.776 L 469.838 249.776 Q 474.428 253.854 481.117 253.854 L 481.117 253.854 L 481.117 253.854 Q 487.855 253.854 492.445 249.776 L 492.445 249.776 L 492.445 249.776 Q 497.035 245.699 497.035 240.963 Z  M 551.869 229.635 L 551.869 229.635 L 551.869 229.635 Q 549.428 228.121 546.742 227.364 L 546.742 227.364 L 546.742 227.364 Q 544.057 226.607 541.127 226.607 L 541.127 226.607 L 541.127 226.607 Q 535.316 226.607 531.898 228.512 L 531.898 228.512 L 531.898 228.512 Q 530.385 229.342 530.385 230.318 L 530.385 230.318 L 530.385 230.318 Q 530.385 231.441 532.436 232.516 L 532.436 232.516 L 532.436 232.516 Q 533.998 233.297 539.418 234.029 L 539.418 234.029 L 539.418 234.029 Q 549.379 235.396 553.285 236.764 L 553.285 236.764 L 553.285 236.764 Q 558.412 238.57 561.195 242.135 L 561.195 242.135 L 561.195 242.135 Q 563.979 245.699 563.979 249.654 L 563.979 249.654 L 563.979 249.654 Q 563.979 255.025 559.242 258.639 L 559.242 258.639 L 559.242 258.639 Q 552.455 263.863 541.615 263.863 L 541.615 263.863 L 541.615 263.863 Q 537.27 263.863 533.583 263.106 L 533.583 263.106 L 533.583 263.106 Q 529.896 262.35 526.82 260.885 L 526.82 260.885 L 526.82 260.885 Q 526.088 261.52 525.258 261.861 L 525.258 261.861 L 525.258 261.861 Q 524.428 262.203 523.549 262.203 L 523.549 262.203 L 523.549 262.203 Q 521.205 262.203 519.813 260.665 L 519.813 260.665 L 519.813 260.665 Q 518.422 259.127 518.422 255.514 L 518.422 255.514 L 518.422 252.145 L 518.422 252.145 Q 518.422 248.531 519.813 246.993 L 519.813 246.993 L 519.813 246.993 Q 521.205 245.455 523.451 245.455 L 523.451 245.455 L 523.451 245.455 Q 525.258 245.455 526.479 246.456 L 526.479 246.456 L 526.479 246.456 Q 527.699 247.457 528.383 249.898 L 528.383 249.898 L 528.383 249.898 Q 530.678 251.852 533.9 252.853 L 533.9 252.853 L 533.9 252.853 Q 537.123 253.854 541.322 253.854 L 541.322 253.854 L 541.322 253.854 Q 548.207 253.854 552.016 251.705 L 552.016 251.705 L 552.016 251.705 Q 553.822 250.631 553.822 249.459 L 553.822 249.459 L 553.822 249.459 Q 553.822 247.506 551.234 246.236 L 551.234 246.236 L 551.234 246.236 Q 548.646 244.967 540.541 244.088 L 540.541 244.088 L 540.541 244.088 Q 528.48 242.818 524.428 239.205 L 524.428 239.205 L 524.428 239.205 Q 520.375 235.641 520.375 230.416 L 520.375 230.416 L 520.375 230.416 Q 520.375 225.045 524.916 221.48 L 524.916 221.48 L 524.916 221.48 Q 531.068 216.598 541.029 216.598 L 541.029 216.598 L 541.029 216.598 Q 544.496 216.598 547.694 217.257 L 547.694 217.257 L 547.694 217.257 Q 550.893 217.916 553.822 219.283 L 553.822 219.283 L 553.822 219.283 Q 554.75 218.6 555.556 218.258 L 555.556 218.258 L 555.556 218.258 Q 556.361 217.916 557.045 217.916 L 557.045 217.916 L 557.045 217.916 Q 559.096 217.916 560.463 219.454 L 560.463 219.454 L 560.463 219.454 Q 561.83 220.992 561.83 224.605 L 561.83 224.605 L 561.83 227.047 L 561.83 227.047 Q 561.83 230.318 561.049 231.49 L 561.049 231.49 L 561.049 231.49 Q 559.486 233.736 556.801 233.736 L 556.801 233.736 L 556.801 233.736 Q 554.994 233.736 553.627 232.613 L 553.627 232.613 L 553.627 232.613 Q 552.26 231.49 551.869 229.635 Z ", Svg.Attributes.fill "#464646" ] [] ]


menu =
    Svg.svg [ Svg.Attributes.width "24", Svg.Attributes.height "24", Svg.Attributes.viewBox "0 0 24 24", Svg.Attributes.fill "none", Svg.Attributes.stroke "currentColor", Svg.Attributes.strokeWidth "2", Svg.Attributes.strokeLinecap "round", Svg.Attributes.strokeLinejoin "round", Svg.Attributes.class "feather feather-menu" ] [ Svg.line [ Svg.Attributes.x1 "3", Svg.Attributes.y1 "12", Svg.Attributes.x2 "21", Svg.Attributes.y2 "12" ] [], Svg.line [ Svg.Attributes.x1 "3", Svg.Attributes.y1 "6", Svg.Attributes.x2 "21", Svg.Attributes.y2 "6" ] [], Svg.line [ Svg.Attributes.x1 "3", Svg.Attributes.y1 "18", Svg.Attributes.x2 "21", Svg.Attributes.y2 "18" ] [] ]


content : (a -> msg) -> (Session.Msg -> msg) -> Session.User -> Html.Html a -> Html.Html msg
content toMsg fromSession ( session, _ ) children =
    let
        renderHeaderButton =
            case session of
                Session.LoggedIn ->
                    Html.a
                        [ Attributes.id "link-app"
                        , Attributes.class "button-link"
                        , Attributes.href <| Url.Builder.absolute [ Dashboard.route ] []
                        ]
                        [ Html.text "Go to the app >" ]

                Session.Anonymous ->
                    Html.a
                        [ Attributes.class "submit header__submit"
                        , Attributes.id "sign-in"
                        , Events.onClick Session.SignIn
                        ]
                        [ Html.text "Sign in" ]
    in
    Html.main_
        [ Attributes.class "content" ]
        [ Html.map fromSession <|
            Html.header [ Attributes.class "header" ]
                [ Html.a [ Attributes.class "logo", Attributes.href <| Url.Builder.absolute [ Home.route ] [] ] [ logo ]
                , renderHeaderButton
                ]
        , Html.map toMsg <| children
        , footer
        ]


header : (Msg -> a) -> Html.Html a
header fromMsg =
    Html.header [ Attributes.class "header -centered" ]
        [ Html.map fromMsg <| Html.button [ Attributes.class "menu-button", Events.onClick ToggleMenu ] [ menu ]
        , Html.a [ Attributes.class "logo -small", Attributes.href Home.route ] [ logo ]
        , Html.a [ Attributes.class "link", Attributes.href Project.createProjectRoute ] [ Html.text "Start" ]
        ]


sidebar : Model -> (Msg -> a) -> (Session.Msg -> a) -> Html.Html a
sidebar model fromSkeleton fromSession =
    let
        menuClass =
            case model of
                Opened ->
                    "side-menu -opened"

                Closed ->
                    "side-menu -closed"
    in
    Html.aside [ Attributes.class menuClass ]
        [ Html.h2 [ Attributes.class "side-menu__title" ] [ Html.text "Your account" ]
        , Html.nav [ Attributes.class "side-menu__links" ]
            [ Html.map fromSkeleton <|
                Html.ul [ Attributes.class "side-menu__links-list", Events.onClick ToggleMenu ]
                    [ Html.li [ Attributes.class "side-menu__links-list-item" ] [ Html.a [ Attributes.href <| Url.Builder.absolute [ Dashboard.route ] [] ] [ Html.text "Created projects" ] ]
                    , Html.li [ Attributes.class "side-menu__links-list-item" ] [ Html.a [ Attributes.href "#" ] [ Html.text "Backed projects" ] ]
                    ]
            , Html.map fromSession <| Html.button [ Attributes.class "submit -inverted -no-margin", Events.onClick Session.SignOut ] [ Html.text "Sign out" ]
            ]
        ]


unauthorizedUserView : (Session.Msg -> msg) -> Html.Html msg
unauthorizedUserView fromSession =
    Html.div
        [ Attributes.class "unauthorized" ]
        [ Html.h1 [ Attributes.class "title" ] [ Html.text "Unauthorized" ]
        , Html.p [] [ Html.text "You are not authorized to view this page" ]
        , Html.map fromSession <| Html.button [ Attributes.class "submit", Attributes.id "sign-in", Events.onClick Session.SignIn ] [ Html.text "Sign in" ]
        ]


application : (a -> msg) -> (Session.Msg -> msg) -> (Msg -> msg) -> Session.User -> Model -> Html.Html a -> Html.Html msg
application toMsg fromSession fromSkeleton ( session, _ ) model children =
    case session of
        Session.LoggedIn ->
            Html.main_ [ Attributes.class "app dashboard" ]
                [ header fromSkeleton
                , sidebar model fromSkeleton fromSession
                , Html.map toMsg <| children
                , footer
                ]

        Session.Anonymous ->
            Html.main_ [ Attributes.class "app dashboard" ]
                [ header fromSkeleton
                , unauthorizedUserView fromSession
                , footer
                ]


footer : Html.Html a
footer =
    Html.footer [ Attributes.class "footer" ]
        [ Html.p [] [ Html.text "Powered by:" ]
        , Html.ul [ Attributes.class "footer-list" ]
            [ Html.li [ Attributes.class "footer-list__item" ]
                [ Html.a [ Attributes.class "link", Attributes.href "https://bitcoin.org/en/", Attributes.target "_blank" ]
                    [ Html.text "Bitcoin" ]
                ]
            , Html.li [ Attributes.class "footer-list__item" ]
                [ Html.a [ Attributes.class "link", Attributes.href "https://blockstack.org/what-is-blockstack/", Attributes.target "_blank" ]
                    [ Html.text "Blockstack" ]
                ]
            ]
        , Html.p [ Attributes.class "footer-disclaimer" ] [ Html.text "2019 - ", Html.a [ Attributes.class "link", Attributes.href "https://github.com/blocosapp/blocos" ] [ Html.text "An open source" ], Html.text " project licensed under GNU GPL v3" ]
        ]
