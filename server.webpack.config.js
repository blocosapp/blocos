const ForkTsCheckerWebpackPlugin = require('fork-ts-checker-webpack-plugin')
const ManifestPlugin = require('webpack-manifest-plugin')
const MiniCssExtractPlugin = require("mini-css-extract-plugin")
const nodeExternals = require('webpack-node-externals')
const path = require('path')
const webpack = require('webpack')

const mode = process.env.NODE_ENV='production' ? 'production' : 'development'

module.exports = {
  devtool: '#source-map',
  entry: {
    bin: './server/index.ts',
  },
  externals: [nodeExternals()],
  mode,
  module: {
    rules: [
      {
        test: /\.ts?$/,
        loader: 'ts-loader',
        options: {
          configFile: path.resolve(__dirname, './server.tsconfig.json'),
          // transpileOnly: true
        }
      }
    ]
  },
  node: {
    __dirname: false,
    __filename: false,
  },
  output: {
    path: path.resolve(__dirname, './server/bin/'),
    filename: 'www'
  },
  plugins: [
    new webpack.BannerPlugin(
      {
        banner: '#!/usr/bin/env node',
        raw: true
      }
    )
    // new ForkTsCheckerWebpackPlugin({
      // options: {
        // configFile: path.resolve(__dirname, './server.tsconfig.json')
      // }
    // })
  ],
  resolve: {
    extensions: [ '.js', '.ts' ],
  },
  target: 'node'
}
