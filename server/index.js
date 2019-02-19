const express = require('express')
const fs = require('fs')
const path = require('path')

const app = express()
const port = 8000

const production = process.env.NODE_ENV === 'production'
const development = !production
const DEV_SERVER_HOST = 'http://localhost:8080'

// @TODO: fix webpack-dev-server url generation
function generateAssetUrl(asset, hashedAssetUrl) {
  return development
    ? `${DEV_SERVER_HOST}/${hashedAssetUrl}`
    : `/${hashedAssetUrl}`
}

function getFiles() {
  const assetsJson = fs.readFileSync(path.resolve(__dirname, './assets.json'), 'utf8')
  const assetsMap =  JSON.parse(assetsJson)

  return Object
    .keys(assetsMap)
    .reduce((prev, current) => ({...prev, [current]: generateAssetUrl(current, assetsMap[current])}), {})
}

const files = getFiles();

app.use(express.static('public'))
app.set('view engine', 'pug')
app.get('*', (req, res) => {
  // @TODO - Check how to deal with cache
  res.render('index', { title: 'Blocos - Descentralized censorship free crowdfunding', files: production ? files : getFiles()})
})


app.listen(port, () => console.log(`Application started to run ${port}!`))
