module Page.NotFound exposing (Msg, title, view)

import Html
import Html.Attributes as Attributes


title : String
title =
    "Page Not Found"


type Msg
    = Nothing


view : Html.Html msg
view =
    Html.div []
        [ Html.h1 [] [ Html.text title ]
        , Html.p [] [ Html.text "We couldn't find the page you are looking for. :(" ]
        ]
