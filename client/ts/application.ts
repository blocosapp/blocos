import { getRandomInts } from './seed'
import { handleAuthentication, handleFiles } from './ports'
import { Elm } from '../elm/Main'

export type App = Elm.Main.App

function generateFlags (): [number, number[]] {
  const seeds = getRandomInts(5)
  return [seeds[0], seeds.slice(1)]
}

export function init (): App {
  const flags = generateFlags()
  const app: App = Elm.Main.init({ flags })
  handleAuthentication(app)
  handleFiles(app)
  return app
}
