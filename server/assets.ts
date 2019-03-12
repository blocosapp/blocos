import * as fs from 'fs'
import path from 'path'
import { BuildMode } from './index'

function generateAssetUrl (hashedAssetUrl: string, host: string): string {
  return `${host}/${hashedAssetUrl}`
}

type Cache = {
  assets?: {},
}

let cache: Cache = {
  assets: undefined
}

type Return = {
  getAssets: () => {}
}

function readAssets (assetsHost: string) {
  const assetsMap = JSON.parse(fs.readFileSync(path.resolve(__dirname, '../assets.json'), 'utf8'))
  const assets = Object
    .keys(assetsMap)
    .reduce((prev, current) => ({ ...prev, [current]: generateAssetUrl(assetsMap[current], assetsHost) }), {})
  cache.assets = assets

  return cache
}

export function initAssets (mode: BuildMode, assetsHost: string): Return {
  cache.assets = undefined

  return {
    getAssets () {
      if (mode === BuildMode.Production && cache.assets) {
        return cache.assets
      }

      return readAssets(assetsHost)
    }
  }
}
