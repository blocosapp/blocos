import { getRandomInts } from './seed'
import { authenticate, handleAuthentication, signOut, putFile } from './ports'
import { Elm } from '../elm/Main'

export type App = Elm.Main.App

function generateFlags (): [number, number[]] {
  const seeds = getRandomInts(5)
  return [seeds[0], seeds.slice(1)]
}

export function init (): App {
  const flags = generateFlags()
  const app: App = Elm.Main.init({ flags })

  app.ports.authenticate.subscribe(authenticate)
  app.ports.signOut.subscribe(signOut)
  app.ports.putFile.subscribe(putFile)

  handleAuthentication(app)

  return app
}
