module RouterTest exposing (testRouter)

import Expect exposing (Expectation)
import Router
import Test exposing (..)
import Url
import Url.Parser


defaultUrl : Url.Url
defaultUrl =
    { protocol = Url.Https
    , host = "blocos.app"
    , port_ = Just 443
    , path = "/404"
    , query = Nothing
    , fragment = Nothing
    }


buildUrl : String -> Url.Url
buildUrl path =
    let
        url =
            "https://blocos.app" ++ path
    in
    Maybe.withDefault defaultUrl (Url.fromString url)


testRouter : Test
testRouter =
    describe
        "Router"
        [ describe "route"
            [ describe "it should return a Route for a given route"
                [ test "home /" <|
                    \_ ->
                        let
                            result =
                                Router.route <| buildUrl "/"

                            expectation =
                                Router.Home
                        in
                        Expect.equal expectation result
                ]
            ]
        ]
