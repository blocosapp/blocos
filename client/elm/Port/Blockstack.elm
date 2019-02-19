port module Port.Blockstack exposing (authenticate, authenticated, checkAuthentication, putFile, signOut)

import Json.Encode as E


port authenticate : () -> Cmd msg


port signOut : () -> Cmd msg


port putFile : E.Value -> Cmd msg


port checkAuthentication : () -> Cmd msg


port authenticated : (E.Value -> msg) -> Sub msg
