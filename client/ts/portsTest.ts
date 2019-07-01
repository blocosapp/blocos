import { AppConfig, default as blockstack, UserSession } from 'blockstack'
import { startPorts, UserData } from './ports'
import { appConfig } from '../config'
import { flushPromises } from '../../helpers/specHelpers'

jest.mock('blockstack', () => ({
  Person: jest.fn(_profile => ({ _profile })),
  handlePendingSignIn: jest.fn(() => Promise.resolve(userMock)),
  isSignInPending: jest.fn(),
  isUserSignedIn: jest.fn(),
  listFiles: jest.fn(async () => jest.fn()),
  loadUserData: jest.fn(),
  redirectToSignIn: jest.fn()
}))

function mockAuthenticatedUser (blockstackMock, user) {
  blockstackMock.UserSession.isUserSignedIn.mockImplementationOnce(() => true)
  blockstackMock.loadUserData.mockImplementationOnce(() => user)
}

function generateAppMock () {
  return {
    ports: {
      authenticate: {
        subscribe: jest.fn()
      },
      deleteFile: {
        subscribe: jest.fn()
      },
      signOut: {
        subscribe: jest.fn()
      },
      putFile: {
        subscribe: jest.fn()
      },
      fileSaved: {
        send:  jest.fn()
      },
      checkAuthentication: {
        subscribe: jest.fn()
      },
      authenticated: {
        send: jest.fn()
      },
      fileDeleted: {
        send: jest.fn()
      }
    }
  }
}

const userMock = {
  username: 'Mr. Mock',
  _profile: {
    image: [
      { contentUrl: 'https://avatar.url' }
    ],
    name: 'Mock'
  },
  profile: {
    image: [
      { contentUrl: 'https://avatar.url' }
    ],
    name: 'Mock'
  },
  decentralizedID: 'id',
  identityAddress: 'address',
  appPrivateKey: 'private-key',
  hubUrl: 'hub://url',
  authResponseToken: 'response-token'
}

function generateUserSessionMock (
  isSignInPending: boolean = false,
  isUserSignedIn: boolean = false
): UserSession {
  const callback = (name: string) => false
  return {
    appConfig,
    store: {
      getSessionData: jest.fn(),
      setSessionData: jest.fn(),
      deleteSessionData: jest.fn()
    },
    decryptContent: jest.fn(),
    deleteFile: jest.fn(),
    encryptContent: jest.fn(),
    generateAndStoreTransitKey: jest.fn(),
    getAuthResponseToken: jest.fn(),
    getFile: jest.fn(),
    getFileUrl: jest.fn(),
    getOrSetLocalGaiaHubConnection: jest.fn(),
    handlePendingSignIn: jest.fn(() => Promise.resolve(userMock)),
    isSignInPending: jest.fn(() => isSignInPending),
    isUserSignedIn: jest.fn(() => isUserSignedIn),
    listFiles: jest.fn((callback) => Promise.resolve(0)),
    loadUserData: jest.fn(() => userMock),
    makeAuthRequest: jest.fn(),
    putFile: jest.fn(),
    redirectToSignIn: jest.fn(),
    redirectToSignInWithAuthRequest: jest.fn(),
    setLocalGaiaHubConnection: jest.fn(),
    signUserOut: jest.fn()
  }
}

describe('port module', () => {
  it('should subscribe to blockstack signIn when handling authenticate subscription', () => {
    const appMock = generateAppMock()
    const userSessionMock = generateUserSessionMock()
    startPorts(appMock, userSessionMock)
    expect(appMock.ports.authenticate.subscribe).toHaveBeenCalled()
  })

  it('should handle signed in user and send it through app port "authenticated" when there is a blockstack user signed in', () => {
    const appMock = generateAppMock()
    const userSessionMock = generateUserSessionMock(false, true)
    startPorts(appMock, userSessionMock)
    expect(appMock.ports.authenticated.send).toHaveBeenCalledWith({
      name: userMock._profile.name,
      profilePicture: userMock._profile.image[0].contentUrl,
      username: userMock.username
    })
  })

  it('should handle pending sign in and then send user through app port "authenticated" when there is a blockstack user with pending signed in', async () => {
    const appMock = generateAppMock()
    const userSessionMock = generateUserSessionMock(true)
    startPorts(appMock, userSessionMock)
    await flushPromises()
    expect(appMock.ports.authenticated.send).toHaveBeenCalledWith({
      name: userMock._profile.name,
      profilePicture: userMock._profile.image[0].contentUrl,
      username: userMock.username
    })
  })

  it('should get list of saved files when user is authenticated', async () => {
    const appMock = generateAppMock()
    const userSessionMock = generateUserSessionMock(false, true)
    startPorts(appMock, userSessionMock)
    await flushPromises()
    expect(userSessionMock.listFiles).toHaveBeenCalled()
  })

  // it('should handle putFile subscription', () => {
    // const appMock = generateAppMock()
    // handleFiles(appMock)
    // expect(appMock.ports.putFile.subscribe).toHaveBeenCalled()
  // })
//
  // it('should handle deleteFile subscription', () => {
    // const appMock = generateAppMock()
    // handleFiles(appMock)
    // expect(appMock.ports.deleteFile.subscribe).toHaveBeenCalled()
  // })
})
