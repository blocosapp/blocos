module Session exposing (Msg(..), Session(..), User, UserData, subscriptions, update)

import Browser.Navigation as Nav
import Json.Decode as Decode
import Json.Encode as Encode
import Port.Blockstack as Blockstack
import Url.Builder


type Session
    = Anonymous
    | LoggedIn


type alias UserData =
    { username : String }


type alias User =
    ( Session, Maybe UserData )


type Msg
    = SignIn
    | SignOut
    | CheckAuthentication
    | SessionChanged User


decodeUser : Encode.Value -> User
decodeUser value =
    let
        decodedUserData =
            Decode.decodeValue userDataDecoder value
    in
    case decodedUserData of
        Ok userData ->
            ( LoggedIn, Just userData )

        Err error ->
            ( Anonymous, Just { username = Decode.errorToString error } )


userDataDecoder : Decode.Decoder UserData
userDataDecoder =
    Decode.map UserData
        (Decode.field "username" Decode.string)


subscriptions : User -> Sub Msg
subscriptions user =
    Blockstack.authenticated (\value -> SessionChanged (decodeUser value))


update : Msg -> ( User, Nav.Key ) -> ( User, Cmd Msg )
update msg ( user, navKey ) =
    case msg of
        SignIn ->
            ( user, Blockstack.authenticate () )

        SignOut ->
            ( user, Blockstack.signOut () )

        CheckAuthentication ->
            ( user, Blockstack.checkAuthentication () )

        SessionChanged ( session, userData ) ->
            let
                sessionChangedCmd =
                    case session of
                        LoggedIn ->
                            Nav.pushUrl navKey (Url.Builder.absolute [ "dashboard" ] [])

                        Anonymous ->
                            Cmd.none

                newUser =
                    ( session, userData )
            in
            ( newUser, sessionChangedCmd )
