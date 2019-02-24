module Main exposing (Model, Msg, main)

import Browser exposing (UrlRequest)
import Browser.Navigation as Nav
import Html exposing (Html, a, button, footer, h1, header, main_, map, p, section, text)
import Html.Attributes exposing (class, href, target)
import Html.Events exposing (onClick)
import Page.Dashboard as Dashboard
import Page.Home as Home
import Page.NotFound as NotFound
import Page.Proof as Proof
import Port.Blockstack as Blockstack
import Project
import Random.Pcg.Extended exposing (initialSeed)
import Router
import Session
import Skeleton
import Svg exposing (g, svg)
import Svg.Attributes
import Url exposing (Url)
import Url.Builder
import Url.Parser exposing (Parser, map, oneOf, parse, s, top)



-- MAIN


main : Program Flag Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }


type alias Flag =
    ( Int, List Int )


type alias Model =
    { page : Router.Page, key : Nav.Key, user : Session.User, projects : Project.Model }



-- @TODO: check authentication throwing command on init


init : Flag -> Url -> Nav.Key -> ( Model, Cmd Msg )
init ( seed, seedExtension ) url navKey =
    ( { key = navKey
      , page = Router.toRoute (Url.toString url)
      , user = ( Session.Anonymous, Nothing )
      , projects = ( Project.emptyProject, [], initialSeed seed seedExtension )
      }
    , Cmd.none
    )



-- @TODO: get this on init


currentChecksum =
    "123"



-- SUBSCRIPTION


subscriptions : Model -> Sub Msg
subscriptions model =
    Session.subscriptions model.user
        |> Sub.map SessionMsg
        |> Sub.map Forward


view : Model -> Browser.Document Msg
view model =
    let
        document =
            case model.page of
                Router.Home ->
                    { title = Home.title
                    , body = Skeleton.content SessionMsg <| Home.view model.user
                    }

                Router.Proof ->
                    { title = Proof.title
                    , body = Skeleton.content ProofMsg <| Proof.view currentChecksum
                    }

                Router.Dashboard ->
                    { title = Dashboard.title
                    , body = Skeleton.application DashboardMsg SessionMsg <| Dashboard.view model.user model.projects
                    }

                Router.CreateProject ->
                    { title = Project.createProjectTitle
                    , body = Skeleton.application ProjectMsg SessionMsg <| Project.createProjectView model.user model.projects
                    }

                _ ->
                    { title = NotFound.title
                    , body = Skeleton.content NotFoundMsg NotFound.view
                    }
    in
    { title = document.title, body = [ Html.map Forward <| document.body ] }



-- UPDATE
-- Proxy Messages - Forwarding message to their respective modules


type ProxyMsg
    = SessionMsg Session.Msg
    | ProofMsg Proof.Msg
    | DashboardMsg Dashboard.Msg
    | ProjectMsg Project.Msg
    | NotFoundMsg NotFound.Msg


proxyMsg : ProxyMsg -> Model -> ( Model, Cmd Msg )
proxyMsg msg model =
    case msg of
        SessionMsg sessionMsg ->
            let
                ( sessionUser, sessionCmds ) =
                    Session.update sessionMsg ( model.user, model.key )
            in
            ( { model | user = sessionUser }, Cmd.map Forward <| Cmd.map SessionMsg sessionCmds )

        ProjectMsg projectMsg ->
            let
                ( newProjects, projectCmds ) =
                    Project.update projectMsg model.projects
            in
            ( { model | projects = newProjects }, Cmd.map Forward <| Cmd.map ProjectMsg projectCmds )

        _ ->
            ( model, Cmd.none )


type Msg
    = LinkClicked UrlRequest
    | Forward ProxyMsg
    | UrlChanged Url


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        Forward msg ->
            proxyMsg msg model

        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    let
                        page =
                            case parse Router.route url of
                                Just answer ->
                                    answer

                                Nothing ->
                                    Router.NotFound
                    in
                    ( { model | page = page }
                    , Nav.pushUrl model.key (Url.toString url)
                    )

                Browser.External url ->
                    ( model
                    , Nav.load url
                    )

        UrlChanged url ->
            case parse Router.route url of
                Just answer ->
                    ( { model | page = answer }, Cmd.none )

                Nothing ->
                    ( { model | page = Router.NotFound }, Cmd.none )
