module Router exposing (Page(..), route)

import Page.Dashboard as Dashboard
import Page.Home as Home
import Page.NotFound as NotFound
import Page.Proof as Proof
import Url
import Url.Parser as Parser exposing ((</>))


type Page
    = Home
    | NotFound
    | Proof
    | Dashboard
    | CreateProject
    | EditProject String


routeParser : Parser.Parser (Page -> a) a
routeParser =
    Parser.oneOf
        [ Parser.map Home Parser.top ]


route : Url.Url -> Page
route url =
    Maybe.withDefault NotFound (Parser.parse routeParser url)
