import * as express from 'express'
import * as fs from 'fs'
import * as path from 'path'

const app: express.Application = express()
const assetsServerHost = process.env.DEV_SERVER_HOST || 'http://localhost:8080'
const port = process.env.PORT || 8000
const production = process.env.NODE_ENV === 'production'
const development = !production

function generateAssetUrl (hashedAssetUrl: string): string {
  return development
    ? `${assetsServerHost}/${hashedAssetUrl}`
    : `/${hashedAssetUrl}`
}

function getFiles (): Object {
  const assetsJson = fs.readFileSync(path.resolve(__dirname, '../assets.json'), 'utf8')
  const assetsMap = JSON.parse(assetsJson)

  return Object
    .keys(assetsMap)
    .reduce((prev, current) => ({ ...prev, [current]: generateAssetUrl(assetsMap[current]) }), {})
}

const files = getFiles()

app.use(express.static(path.resolve(__dirname, '../public')))

app.engine('pug', require('pug').__express)
app.set('view engine', 'pug')
app.set('views', path.resolve(__dirname, '../views'))

app.get('*', (req: express.Request, res: express.Response) => {
  res.render('index', { title: 'Blocos - Descentralized censorship free crowdfunding', files: production ? files : getFiles() })
})

app.listen(port, () => console.log(`Application started to run ${port}!`))
