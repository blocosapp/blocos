import * as blockstack from 'blockstack'
import { Elm } from '../elm/Main'

// CRYPTO
const { crypto } = window
const getRandomInts = (n: number) => {
  const randInts = new Uint32Array(n)
  crypto.getRandomValues(randInts)
  return Array.from(randInts)
}

// FLAG GENERATION
// const randInts = getRandomInts(5);
// const flags = [randInts[0], randInts.slice(1)]
const flags: [number, number[]] = [0, [1, 2, 3]]
const app = Elm.Main.init({ flags })

app.ports.authenticate.subscribe(function (data) {
  blockstack
    .redirectToSignIn(
      'https://in.blocos.app',
      'https://blocos.app/manifest.json',
      ['scope']
    )
})

app.ports.signOut.subscribe(function (data) {
  blockstack.signUserOut('/')
})

app.ports.putFile.subscribe(function (data) {
  const fileFolder = data.id
  const fileContent = JSON.stringify(data)
  blockstack
    .putFile(fileFolder + '.json', fileContent)
  // @TODO Imeplement subscription when file was successfully persisted
  // @TODO implement subscription to handle error
})

function getFiles () {
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
          return true
        })
          .then(dt => console.log('promise', dt))
          .catch(console.error)
      }
    })
    // .catch(app.ports.bridgeError.send)
    // @TODO implement an error handler here
}
