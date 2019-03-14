import * as blockstack from 'blockstack'
import { authenticate, handleAuthentication, putFile, signOut } from './ports'
import { flushPromises } from '../../helpers/specHelpers'

jest.mock('blockstack', () => ({
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
  describe('should handle authentication communication between ports', () => {
    it('should redirect to blockstack sign in on authenticate', () => {
      authenticate()
      expect(blockstack.redirectToSignIn).toHaveBeenCalled()
    })

    it('should handle signed in user and send it through app port "authenticated"', () => {
      const userMock = { username: 'Mr. Mock' }
      const appMock = generateAppMock()
      mockAuthenticatedUser(blockstack, userMock)
      handleAuthentication(appMock)
      expect(appMock.ports.authenticated.send).toHaveBeenCalledWith(userMock)
    })

    it('should handle pending sign in and then send user through app port "authenticated"', async () => {
      const userMock = { username: 'Mr. Mock' }
      const appMock = generateAppMock()
      mockPendingAuthenticationUser(blockstack, userMock)
      handleAuthentication(appMock)
      await flushPromises()
      expect(appMock.ports.authenticated.send).toHaveBeenCalledWith(userMock)
    })
  })
})
