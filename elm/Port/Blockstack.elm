port module Port.Blockstack exposing (authenticate, authenticated, checkAuthentication, signOut)

import Json.Encode as E


port authenticate : () -> Cmd msg


port signOut : () -> Cmd msg


port checkAuthentication : () -> Cmd msg


port authenticated : (E.Value -> msg) -> Sub msg
