import * as blockstack from 'blockstack'
import { App } from './Application'

type Project = {
  uuid: string,
  address?: string,
  description: string,
  featuredImageUrl?: string,
  goal: number,
  title: string
}

function authenticate (): void {
  blockstack
    .redirectToSignIn(
      'https://in.blocos.app',
      'https://blocos.app/manifest.json',
      ['scope']
    )
}

function signOut (): void {
  blockstack.signUserOut('/')
}

export function handleAuthentication (app: App): void {
  app.ports.authenticate.subscribe(authenticate)
  app.ports.signOut.subscribe(signOut)

  if (blockstack.isUserSignedIn()) {
    const user = blockstack.loadUserData()
    if (user) {
      return app.ports.authenticated.send(user)
    }

  }
  if (blockstack.isSignInPending()) {
    blockstack
      .handlePendingSignIn()
      .then(user => {
        if (user) {
          return app.ports.authenticated.send(user)
        }
      })
      .catch()
  }
}

export function handleFiles (app: App): void {
  const fileSaved = app.ports.fileSaved.send
  app.ports.putFile.subscribe(project => {
    const fileName = project.uuid
    const fileContent = JSON.stringify(project)
    blockstack
      .putFile(fileName + '.json', fileContent)
      .then(() => fileSaved(project))
      .catch()
  })
}
