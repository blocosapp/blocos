port module Port.Blockstack exposing (authenticate, authenticated, checkAuthentication, deleteFile, fileDeleted, fileSaved, putFile, signOut)

import Json.Encode as E
import Prng.Uuid as Uuid


port authenticate : () -> Cmd msg


port signOut : () -> Cmd msg


port putFile : E.Value -> Cmd msg


port deleteFile : E.Value -> Cmd msg


port checkAuthentication : () -> Cmd msg


port authenticated : (E.Value -> msg) -> Sub msg


port fileSaved : (E.Value -> msg) -> Sub msg


port fileDeleted : (() -> msg) -> Sub msg
