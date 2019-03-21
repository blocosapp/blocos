import * as blockstack from 'blockstack'
import { handleFiles, handleAuthentication } from './ports'
import { flushPromises } from '../../helpers/specHelpers'

jest.mock('blockstack', () => ({
  listFiles: jest.fn(async () => jest.fn()),
  handlePendingSignIn: jest.fn(),
  loadUserData: jest.fn(),
  isUserSignedIn: jest.fn(),
  isSignInPending: jest.fn(),
  redirectToSignIn: jest.fn()
}))

function mockAuthenticatedUser (blockstackMock, user) {
  blockstackMock.isUserSignedIn.mockImplementationOnce(() => true)
  blockstackMock.loadUserData.mockImplementationOnce(() => user)
}

function mockPendingAuthenticationUser (blockstackMock, user) {
  blockstackMock.isUserSignedIn.mockImplementationOnce(() => false)
  blockstackMock.isSignInPending.mockImplementationOnce(() => true)
  blockstackMock.handlePendingSignIn.mockImplementationOnce(async () => user)
}

function generateAppMock () {
  return {
    ports: {
      authenticate: {
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
      }
    }
  }
}

describe('port module', () => {
  it('should subscribe to blockstack signIn when handling authenticate subscription', () => {
    const appMock = generateAppMock()
    handleAuthentication(appMock)
    expect(appMock.ports.authenticate.subscribe).toHaveBeenCalled()
  })

  it('should handle signed in user and send it through app port "authenticated" when there is a blockstack user signed in', () => {
    const userMock = { username: 'Mr. Mock' }
    const appMock = generateAppMock()
    mockAuthenticatedUser(blockstack, userMock)
    handleAuthentication(appMock)
    expect(appMock.ports.authenticated.send).toHaveBeenCalledWith(userMock)
  })

  it('should handle pending sign in and then send user through app port "authenticated" when there is a blockstack user with pending signed in', async () => {
    const userMock = { username: 'Mr. Mock' }
    const appMock = generateAppMock()
    mockPendingAuthenticationUser(blockstack, userMock)
    handleAuthentication(appMock)
    await flushPromises()
    expect(appMock.ports.authenticated.send).toHaveBeenCalledWith(userMock)
  })

  it('should handle putFile subsription and fetch new files when handling files', () => {
    const appMock = generateAppMock()
    handleFiles(appMock)
    expect(appMock.ports.putFile.subscribe).toHaveBeenCalled()
    expect(blockstack.listFiles).toHaveBeenCalled()
  })
})
