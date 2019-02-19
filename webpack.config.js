const path = require('path')
const ManifestPlugin = require('webpack-manifest-plugin')
const MiniCssExtractPlugin = require("mini-css-extract-plugin")

const isProduction = process.env.NODE_ENV='production'

module.exports = {
  entry: {
    lib: './client/js/lib.js',
    styles: './client/scss/index.scss',
  },
  // devServer: {},
  mode: 'development',
  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        loader: "elm-webpack-loader",
        options: {
          debug: true
        }
      },
      {
        test: /\.scss$/,
        use: [
          MiniCssExtractPlugin.loader,
          'css-loader',
          'sass-loader',
        ]
      }
    ]
  },
  optimization: {
    splitChunks: {
      cacheGroups: {
        styles: {
          name: 'styles',
          test: /\.scss$/,
          chunks: 'all',
          enforce: true
        }
      }
    }
  },
  output: {
    path: path.resolve(__dirname, './server/public/'),
    filename: isProduction ? 'js/lib.[hash].js' : 'js/lib.js'
  },
  plugins: [
    new ManifestPlugin({
        fileName: '../assets.json',
        writeToFileEmit: true
    }),
    new MiniCssExtractPlugin({
        filename: isProduction ? "css/syles.[hash].css" : "css/syles.css",
    })
  ]
}
