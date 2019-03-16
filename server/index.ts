import express from 'express'
import cors from 'cors'
import fs from 'fs'
import path from 'path'
import { initAssets } from './assets'

export enum BuildMode {
  Development = 'development',
  Production = 'production'
}

const app: express.Application = express()
const port: number = Number(process.env.PORT) || 8000
const buildMode: BuildMode = process.env.NODE_ENV === 'production'
  ? BuildMode.Production
  : BuildMode.Development

const assetsServerHost: string = buildMode === BuildMode.Production
  ? (process.env.HOST || `http://localhost:${port}`)
  : process.env.DEV_SERVER_HOST || 'http://localhost:8080'
const { getAssets } = initAssets(buildMode, assetsServerHost)

app.engine('pug', require('pug').__express)
app.set('view engine', 'pug')
app.set('views', path.resolve(__dirname, '../views'))

app.get('/manifest.json', cors(), (req: express.Request, res: express.Response) => {
  const manifestFile = JSON.parse(fs.readFileSync(path.resolve(__dirname, '../public/manifest.json'), 'utf8'))
  res.json(manifestFile)
})

app.use(express.static(path.resolve(__dirname, '../public')))

app.get('*', (req: express.Request, res: express.Response) => {
  const { assets } = getAssets()
  res.render('index', { title: 'Blocos - Descentralized censorship free crowdfunding', assets })
})

app.listen(port, () => console.log(`Application started to run ${port} in ${buildMode} mode.`))
