port module Port.Blockstack exposing (ProjectFile, authenticate, authenticated, checkAuthentication, fileSaved, putFile, signOut)

import Json.Encode as E
import Uuid


type alias ProjectFile =
    { address : Maybe String
    , description : String
    , featuredImageUrl : String
    , goal : Float
    , uuid : String
    , title : String
    }


port authenticate : () -> Cmd msg


port signOut : () -> Cmd msg


port putFile : ProjectFile -> Cmd msg


port checkAuthentication : () -> Cmd msg


port authenticated : (E.Value -> msg) -> Sub msg


port fileSaved : (ProjectFile -> msg) -> Sub msg
