port module Port.Blockstack exposing (ProjectFile, authenticate, authenticated, checkAuthentication, putFile, signOut)

import Json.Encode as E
import Uuid


type alias ProjectFile =
    { address : Maybe String
    , description : String
    , goal : Float
    , id : String
    , title : String
    }


port authenticate : () -> Cmd msg


port signOut : () -> Cmd msg


port putFile : ProjectFile -> Cmd msg


port checkAuthentication : () -> Cmd msg


port authenticated : (E.Value -> msg) -> Sub msg
