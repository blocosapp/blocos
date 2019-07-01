import { UserSession as UserSessionMock } from 'blockstack'
import { init } from './application'
import { getRandomInts as getRandomIntsMock } from './seed'
import { startPorts as startPortsMock } from './ports'
import { appConfig } from '../config'
import { Elm as ElmMock } from '../elm/Main'

jest.mock('blockstack', () => ({
  UserSession: jest.fn()
}))

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
jest.mock('../elm/Main', () => ({
  Elm: {
    Main: {
      init: jest.fn(() => appMock)
    }
  }
}))

jest.mock('./seed', () => ({
  getRandomInts: jest.fn(() => [1, 2, 3, 4, 5])
}))

jest.mock('./ports', () => ({
  startPorts: jest.fn()
}))

describe('application bootstrap module', () => {
  it('should bootstrap the application', () => {
    init()
    expect(getRandomIntsMock).toHaveBeenCalledWith(5)
    expect(UserSessionMock).toHaveBeenCalledWith({ appConfig })
    expect(startPortsMock).toHaveBeenCalledWith(appMock, {})
  })
})
