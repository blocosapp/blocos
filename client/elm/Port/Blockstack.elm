port module Port.Blockstack exposing (ProjectFile, authenticate, authenticated, checkAuthentication, deleteFile, fileDeleted, fileSaved, putFile, signOut)

import Json.Encode as E
import Prng.Uuid as Uuid


type alias ProjectFileReward =
    { id : Int, title : String, contribution : Float, description : String }


type alias ProjectFile =
    { uuid : String
    , address : Maybe String
    , cardImageUrl : String
    , coverImageUrl : String
    , description : String
    , duration : Int
    , goal : Float
    , projectHash : String
    , projectHubUrl : String
    , projectVideoUrl : String
    , rewards : List ProjectFileReward
    , tagline : String
    , title : String
    }


port authenticate : () -> Cmd msg


port signOut : () -> Cmd msg


port putFile : ProjectFile -> Cmd msg


port deleteFile : ProjectFile -> Cmd msg


port checkAuthentication : () -> Cmd msg


port authenticated : (E.Value -> msg) -> Sub msg


port fileSaved : (ProjectFile -> msg) -> Sub msg


port fileDeleted : (() -> msg) -> Sub msg
