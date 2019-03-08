import { init } from './application'
import { getRandomInts as getRandomIntsMock } from './seed'
import { authenticate, handleAuthentication as handleAuthenticationMock, signOut, putFile } from './ports'
import { Elm } from '../elm/Main'

jest.mock('../elm/Main', () => {
  const appMock = {
    ports: {
      authenticate: {
        subscribe: jest.fn()
      },
      signOut: {
        subscribe: jest.fn()
      },
      putFile: {
        subscribe: jest.fn()
      }
    }
  }

  return {
    Elm: {
      Main: {
        init: jest.fn(() => appMock)
      }
    }
  }
})

jest.mock('./seed', () => ({
  getRandomInts: jest.fn(() => [1, 2, 3, 4, 5])
}))

jest.mock('./ports', () => ({
  authenticate: jest.fn(),
  handleAuthentication: jest.fn(),
  signOut: jest.fn(),
  putFile: jest.fn()
}))

describe('application bootstrap module', () => {
  it('should bootstrap the application', () => {
    const app = init()
    expect(getRandomIntsMock).toHaveBeenCalledWith(5)
    expect(app.ports.authenticate.subscribe).toHaveBeenCalledWith(authenticate)
    expect(app.ports.signOut.subscribe).toHaveBeenCalledWith(signOut)
    expect(app.ports.putFile.subscribe).toHaveBeenCalledWith(putFile)
    expect(handleAuthenticationMock).toHaveBeenCalledWith(app)
  })
})
