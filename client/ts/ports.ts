import * as blockstack from 'blockstack'
import { App } from './Application'

type Project = {
  id?: string,
  address?: string,
  description: string,
  goal: number,
  title: string
}

export function authenticate (): void {
  blockstack
    .redirectToSignIn(
      'https://in.blocos.app',
      'https://blocos.app/manifest.json',
      ['scope']
    )
}

export function handleAuthentication (app: App): void {
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

export function putFile (project: Project): void {
  const fileName = project.id
  const fileContent = JSON.stringify(project)
  blockstack
    .putFile(fileName + '.json', fileContent)
    .then()
    .catch()
}

export function signOut (): void {
  blockstack.signUserOut('/')
}
