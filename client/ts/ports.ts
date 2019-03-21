import * as blockstack from 'blockstack'
import { App } from './Application'

type Project = {
  uuid: string,
  address: string,
  description: string,
  featuredImageUrl: string,
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

function parseFile (fileContent: string): Project {
  try {
    const parsedFile = JSON.parse(fileContent)
    if (!parsedFile.uuid) {
      return null
    }

    return {
      uuid: parsedFile.uuid,
      address: parsedFile.address || '',
      description: parsedFile.description || '',
      featuredImageUrl: parsedFile.featuredImageUrl || '',
      goal: typeof parsedFile.goal === 'number' ? parsedFile.goal : 0,
      title: parsedFile.title || ''
    }
  } catch (error) {
    console.error(error)
  }
}

function fetchFile (app: App): (arg0: string) => boolean {
  return (filePath: string) => {
    blockstack
      .getFile(filePath, null)
      .then(savedFile => {
        const parsedFile = parseFile(savedFile)
        if (parsedFile) {
          app.ports.fileSaved.send(parsedFile)
        }
      })
      .catch(console.error)
    return true
  }
}

function fetchNewFiles (app: App): void {
  blockstack
    .listFiles(fetchFile(app))
    .catch(console.error)
}

function subscribeToPutFile (app: App, fileSaved: (arg0: Project) => void) {
  app.ports.putFile.subscribe(project => {
    const fileName = project.uuid
    const fileContent = JSON.stringify(project)
    blockstack
      .putFile(fileName + '.json', fileContent)
      .then(() => fileSaved(project))
      .catch()
  })
}

export function handleFiles (app: App): void {
  subscribeToPutFile(app, app.ports.fileSaved.send)
  fetchNewFiles(app)
}
