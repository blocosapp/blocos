import { default as blockstack, UserSession, AppConfig } from 'blockstack'
import { getRandomInts } from './seed'
import { Elm } from '../elm/Main'
import { startPorts } from './ports'
import { appConfig, apiConfig } from '../config'

type Flags = {
  apiDomain: string,
  appDomain: string,
  seed: number,
  seedExtension: number[]
}

function generateFlags (): Flags {
  const seeds = getRandomInts(5)
  const { apiDomain } = apiConfig
  const { appDomain } = appConfig
  return {
    apiDomain,
    appDomain,
    seed: seeds[0],
    seedExtension: seeds.slice(1)
  }
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
