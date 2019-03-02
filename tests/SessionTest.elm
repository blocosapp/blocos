module SessionTest exposing (sessionTest)

import Test exposing (..)



-- @TODO: figure out how to properly test this.
-- The module is basically a group of updta msgs,
-- so maybe E2E coverage of those use cases
-- would be fine (though expensive).


sessionTest : Test
sessionTest =
    describe
        "Session"
        [ describe "update"
            [ todo "Should change the user session and redirect to Dashboard when logged in"
            , todo "Should tigger port on SignIn"
            , todo "Should trigger port on SignOut"
            , todo "Should trigger port on CheckAuthentication"
            , todo "Should change session on SessionChanged"
            ]
        ]
