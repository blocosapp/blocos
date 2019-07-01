import { default as blockstack, UserSession, AppConfig } from 'blockstack'
import { getRandomInts } from './seed'
import { Elm } from '../elm/Main'
import { startPorts } from './ports'
import { appConfig } from '../config'

function generateFlags (): [number, number[]] {
  const seeds = getRandomInts(5)
  return [seeds[0], seeds.slice(1)]
}

function createSession (): UserSession {
  return new UserSession({ appConfig })
}

export function init (): void {
  const flags = generateFlags()
  const app = Elm.Main.init({ flags })
  const session = createSession()
  startPorts(app, session)
}
