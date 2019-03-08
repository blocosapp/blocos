import * as blockstackMock from 'blockstack'
import { authenticate, handleAuthentication, putFile, signOut } from './ports'
import { flushPromises } from '../../helpers/specHelpers'

jest.mock('blockstack', () => ({
  handlePendingSignIn: jest.fn(),
  loadUserData: jest.fn(),
  isUserSignedIn: jest.fn(),
  isSignInPending: jest.fn(),
  redirectToSignIn: jest.fn()
}))

function mockAuthenticatedUser (user) {
  blockstackMock.isUserSignedIn.mockImplementationOnce(() => true)
  blockstackMock.loadUserData.mockImplementationOnce(() => user)
}

function mockPendingAuthenticationUser (user) {
  blockstackMock.isUserSignedIn.mockImplementationOnce(() => false)
  blockstackMock.isSignInPending.mockImplementationOnce(() => true)
  blockstackMock.handlePendingSignIn.mockImplementationOnce(async () => user)
}

describe('port module', () => {
  describe('should handle authentication communication between ports', () => {
    it('should redirect to blockstack sign in on authenticate', () => {
      authenticate()
      expect(blockstackMock.redirectToSignIn).toHaveBeenCalled()
    })

    it('should handle signed in user and send it through app port "authenticated"', () => {
      const userMock = { username: 'Mr. Mock' }
      const appMock = {
        ports: {
          authenticated: {
            send: jest.fn()
          }
        }
      }
      mockAuthenticatedUser(userMock)
      handleAuthentication(appMock)
      expect(appMock.ports.authenticated.send).toHaveBeenCalledWith(userMock)
    })

    it('should handle pending sign in and then send user through app port "authenticated"', async () => {
      const userMock = { username: 'Mr. Mock' }
      const appMock = {
        ports: {
          authenticated: {
            send: jest.fn()
          }
        }
      }
      mockPendingAuthenticationUser(userMock)
      handleAuthentication(appMock)
      await flushPromises()
      expect(appMock.ports.authenticated.send).toHaveBeenCalledWith(userMock)
    })
  })
})
