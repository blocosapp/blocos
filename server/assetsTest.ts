import express from 'express'
import * as fsMock from 'fs'
import { initAssets } from './assets'
import { BuildMode } from './index'

jest.mock('express')

jest.mock('fs', () => ({
  readFileSync: jest.fn(() => JSON.stringify({ 'file': 'file.json' }))
}))

jest.mock('./index', () => ({
  BuildMode: {
    Development: 'dev',
    Production: 'prod'
  }
}))

describe('Assets module', () => {
  it('should allow assets to be retrieved when it is initialized', () => {
    const mode = BuildMode.Production
    const host = 'http://test.assets'
    const result = initAssets(mode, host)
    expect(result.getAssets).toBeDefined()
  })

  it('should always read the assets file when it is initalized in development mode', () => {
    const mode = BuildMode.Development
    const host = 'http://test.assets'
    const result = initAssets(mode, host)
    result.getAssets()
    result.getAssets()
    expect(fsMock.readFileSync).toHaveBeenCalledTimes(2)
  })

  it('should read assets from cache when it is initalized in production mode', () => {
    const mode = BuildMode.Production
    const host = 'http://test.assets'
    const result = initAssets(mode, host)
    result.getAssets()
    result.getAssets()
    result.getAssets()
    expect(fsMock.readFileSync).toHaveBeenCalledTimes(1)
  })
})
