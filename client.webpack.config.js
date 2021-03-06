const path = require('path')
const ManifestPlugin = require('webpack-manifest-plugin')
const MiniCssExtractPlugin = require("mini-css-extract-plugin")
const webpack = require('webpack');

const isProduction = process.env.NODE_ENV === 'production'

module.exports = {
  entry: {
    lib: './client/ts/lib.ts',
    styles: './client/scss/index.scss',
  },
  devServer: {
    inline: true
  },
  mode: isProduction ? 'production' : 'development',
  module: {
    rules: [
      {
        test: /\.elm$/,
        exclude: [/elm-stuff/, /node_modules/],
        use: [
          {
            loader: 'elm-webpack-loader',
            options: {
              debug: !isProduction,
              forceWatch: !isProduction
            }
          }
        ]
      },
      {
        test: /\.scss$/,
        use: [
          MiniCssExtractPlugin.loader,
          'css-loader',
          'sass-loader',
        ]
      },
      {
        test: /\.ts$/,
        loader: 'ts-loader',
        exclude: [/node_modules/, /server/],
        options: {
          configFile: 'client.tsconfig.json'
        }
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
    }),
    new webpack.HotModuleReplacementPlugin(),
  ],
  resolve: {
    extensions: [ '.elm', '.js', '.ts' ],
  }
}
