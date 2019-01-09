import * as blockstack from 'blockstack'

const app = window.Elm.Main.init({flags: 'not authenticated'})

app.ports.authenticate.subscribe(function (data) {
  blockstack.redirectToSignIn()
})

app.ports.authenticate.subscribe(function (data) {
  blockstack.redirectToSignIn()
})

app.ports.signOut.subscribe(function (data) {
  blockstack.signUserOut('/')
})


if (blockstack.isUserSignedIn()) {
	const user = blockstack.loadUserData()
  if (user) {
    app.ports.authenticated.send(user)
  }
} else if (blockstack.isSignInPending()) {
  blockstack.handlePendingSignIn().then((user) => {
    if (user) {
      app.ports.authenticated.send(user)
    }
  })
}

