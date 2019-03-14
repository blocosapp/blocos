import * as fs from 'fs'
import path from 'path'
import { BuildMode } from './index'

function generateAssetUrl (hashedAssetUrl: string, host: string): string {
  return `${host}/${hashedAssetUrl}`
}

type Cache = {
  assets?: {}
}

let cache: Cache = {
  assets: undefined
}

type AssetsManager = {
  getAssets: () => Cache
}

function readAssets (assetsHost: string): Cache {
  const assetsMap = JSON.parse(fs.readFileSync(path.resolve(__dirname, '../assets.json'), 'utf8'))
  const assets = Object
    .keys(assetsMap)
    .reduce((prev, current) => ({ ...prev, [current]: generateAssetUrl(assetsMap[current], assetsHost) }), {})
  cache.assets = assets

  return cache
}

export function initAssets (mode: BuildMode, assetsHost: string): AssetsManager {
  cache.assets = undefined

  return {
    getAssets (): Cache {
      if (mode === BuildMode.Production && cache.assets) {
        return cache.assets
      }

      return readAssets(assetsHost)
    }
  }
}
