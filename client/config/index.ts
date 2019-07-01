import { AppConfig } from 'blockstack'

export const appConfig: AppConfig = {
  appDomain: 'http://localhost:8000',
  coreNode: null,
  manifestPath: 'http://localhost:8000/manifest.json',
  manifestURI: () => 'http://localhost:8000/manifest.json',
  redirectPath: 'http://localhost:8000',
  redirectURI: () => 'http://localhost:8000',
  scopes: ['publish_data']
}
