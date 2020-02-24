const webpack = require('webpack');
const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const moment = require('moment');

const config = {
  output: {
     filename: 'main.js',
     path: path.resolve(__dirname, 'build')
   },
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        resolve: {
          extensions: [".js", ".jsx"]
        },
        use: {
          loader: "babel-loader"
        }
      }
    ]
  },
  plugins: [
    new webpack.DefinePlugin({
      timestamp: JSON.stringify(moment().utc().format()),
      color: function(){
        const colors = ['OVERSKYET', 'SOLOPPGANG', 'SKYFRITT', 'SOLNEDGANG', 'KVELD', 'NATT', 'REGN', 'GUL', 'GRØNN']
        return JSON.stringify(colors[Math.floor(Math.random()*colors.length)])
      }()
    })
  ]
};

module.exports = (env, argv) => {

  if (argv.mode === 'development') {
    config.plugins.push(
      new HtmlWebpackPlugin({
        chunk: true,
        title: 'Hotloading index.html for development',
        template: './dev-index.html',
        filename: 'dev-index.html'
      }));
    config.devServer = {
      openPage: 'dev-index.html'
    }
  };

  return config;
};
