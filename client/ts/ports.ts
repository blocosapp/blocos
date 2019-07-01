import { default as blockstack, AppConfig, Person, UserSession } from 'blockstack'
import { Elm } from '../elm/Main'

type App = Elm.Main.App

type Reward = {
  id: number,
  title: string,
  description: string,
  contribution: number
}

type Project = {
  address: string,
  cardImageUrl: string,
  coverImageUrl: string,
  description: string,
  goal: number,
  projectVideoUrl: string,
  rewards: Array<Reward>,
  tagline: string,
  title: string,
  uuid: string
}

export type UserData = {
  username: string;
  email?: string;
  _profile?: any;
}

function authenticate (session: UserSession): void {
  session.redirectToSignIn()
}

function signOut (session: UserSession): void {
  session.signUserOut('/')
}

function getProfilePicture (person: Person): string {
  return (person._profile
    && person._profile.image
    && person._profile.image.length > 0
    && person._profile.image[0].contentUrl) || null
}

function getName (person: Person): string {
  return (person._profile && person._profile.name) || null
}

function doAuthentication (userData: UserData, userSession: UserSession, app: App) {
  const { _profile, username } = userData
  const person = new Person(_profile)
  const appProfile = {
    username,
    name: getName(person),
    profilePicture: getProfilePicture(person)
  }
  app.ports.authenticated.send(appProfile)
  fetchSavedFiles(app, userSession)
}

function handleAuthentication (app: App, session: UserSession): void {
  app.ports.authenticate.subscribe(() => authenticate(session))
  app.ports.signOut.subscribe(() => signOut(session))

  if (session.isUserSignedIn()) {
    const user = session.loadUserData()
    if (user) {
      doAuthentication(user, session, app)
    }
  }

  if (session.isSignInPending()) {
    session
      .handlePendingSignIn()
      .then(user => {
        if (user) {
          doAuthentication(user, session, app)
        }
      })
      .catch(console.error)
  }
}

function parseRewards (rewards: Array<any>) {
  return rewards.map(reward => ({
    id: reward.id || -1,
    title: reward.title || '',
    description: reward.description || '',
    contribution: reward.contribution || 0
  }))
}

function parseFile (fileContent: string): Project | null {
  if (!fileContent) {
    return null
  }

  try {
    const parsedFile = JSON.parse(fileContent)
    if (!parsedFile.uuid) {
      return null
    }

    return {
      uuid: parsedFile.uuid,
      address: parsedFile.address || '',
      description: parsedFile.description || '',
      goal: typeof parsedFile.goal === 'number' ? parsedFile.goal : 0,
      title: parsedFile.title || '',
      cardImageUrl: parsedFile.cardImageUrl || '',
      coverImageUrl: parsedFile.coverImageUrl || '',
      projectVideoUrl: parsedFile.projectVideoUrl || '',
      rewards: parseRewards(parsedFile.rewards || []),
      tagline: parsedFile.tagline || ''
    }
  } catch (error) {
    console.error(error)
  }
}

function fetchFile (app: App, userSession: UserSession): (arg0: string) => boolean {
  return (filePath: string) => {
    userSession
      .getFile(filePath, null)
      .then(savedFile => {
        if (typeof savedFile === 'string') {
          const parsedFile = parseFile(savedFile)
          if (parsedFile) {
            app.ports.fileSaved.send(parsedFile)
          }
        }
      })
      .catch(console.error)
    return true
  }
}

// @TODO: add a flag to tell if still waiting for files to be fetched or not
function fetchSavedFiles (app: App, user: UserSession): void {
  user
    .listFiles(fetchFile(app, user))
    .catch(console.error)
}

function subscribeToPutFile (app: App, user: UserSession, fileSaved: (arg0: Project) => void) {
  app.ports.putFile.subscribe(project => {
    const fileName = project.uuid
    try {
      const fileContent = JSON.stringify(project)
      user
        .putFile(fileName + '.json', fileContent)
        .then(() => fileSaved(project))
        .catch(console.error)
    } catch (e) {
      console.error(e)
    }
  })
}

function subscribeToDeleteFile (app: App, user: UserSession, fileDeleted: (data: null) => void) {
  app.ports.deleteFile.subscribe(project => {
    const fileName = project.uuid + '.json'
    user
      .deleteFile(fileName)
      .then(() => fileDeleted(null))
      .catch(console.error)
  })
}

function handleFiles (app: App, user: UserSession): void {
  subscribeToPutFile(app, user, app.ports.fileSaved.send)
  subscribeToDeleteFile(app, user, app.ports.fileDeleted.send)
}

export function startPorts (app: App, user: UserSession) {
  handleFiles(app, user)
  handleAuthentication(app, user)
}
