import * as blockstack from 'blockstack'
import { Elm } from '../elm/Main.elm'

// CRYPTO
const crypto = window.crypto || window.msCrypto;
const getRandomInts = (n) => {
  const randInts = new Uint32Array(n);
  crypto.getRandomValues(randInts);
  return Array.from(randInts);
};

// FLAG GENERATION
const randInts = getRandomInts(5);
const flags = [randInts[0], randInts.slice(1)]
const app = Elm.Main.init({flags})

app.ports.authenticate.subscribe(function (data) {
  blockstack.redirectToSignIn()
})

app.ports.authenticate.subscribe(function (data) {
  blockstack.redirectToSignIn()
})

app.ports.signOut.subscribe(function (data) {
  blockstack.signUserOut('/')
})

app.ports.putFile.subscribe(function (data) {
  const fileFolder = data.id
  const fileContent = JSON.stringify(data)
  blockstack
    .putFile(fileFolder + '.json', fileContent)
    .then(app.ports.filePersisted.send)
    .catch(app.ports.bridgeError.send)
})

function getFiles() {
  blockstack.listFiles((dt) => {
    console.log('callback', dt)
    return true
  })
    .then(dt => console.log('promise', dt))
    .catch(console.error)

}

// -------------------------------
// Authentication & Initialization
// -------------------------------
if (blockstack.isUserSignedIn()) {
	const user = blockstack.loadUserData()
  if (user) {
    app.ports.authenticated.send(user)
    getFiles()
  }
} else if (blockstack.isSignInPending()) {
  blockstack
    .handlePendingSignIn()
    .then((user) => {
      if (user) {
        app.ports.authenticated.send(user)
        blockstack.listFiles((dt) => {
          console.log('callback', dt)
          return true;
        })
          .then(dt => console.log('promise', dt))
          .catch(console.error);
      }
    })
    .catch(app.ports.bridgeError.send)
}

