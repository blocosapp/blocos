module Router exposing (Page(..), route, toRoute)

import Page.CreateProject as CreateProject
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


route : Parser.Parser (Page -> a) a
route =
    Parser.oneOf
        [ Parser.map Home Parser.top
        , Parser.map Proof (Parser.s Proof.route)
        , Parser.map Dashboard (Parser.s Dashboard.route)
        , Parser.map CreateProject (Parser.s "projects" </> Parser.s "new")
        ]


toRoute : String -> Page
toRoute urlString =
    case Url.fromString urlString of
        Nothing ->
            NotFound

        Just url ->
            Maybe.withDefault NotFound (Parser.parse route url)
