import { init } from './application'
import { getRandomInts as getRandomIntsMock } from './seed'
import {
  handleAuthentication as handleAuthenticationMock,
  handleFiles as handleFilesMock
} from './ports'
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
  handleAuthentication: jest.fn(),
  handleFiles: jest.fn()
}))

describe('application bootstrap module', () => {
  it('should bootstrap the application', () => {
    const app = init()
    expect(getRandomIntsMock).toHaveBeenCalledWith(5)
    expect(handleAuthenticationMock).toHaveBeenCalledWith(app)
    expect(handleFilesMock).toHaveBeenCalledWith(app)
  })
})
