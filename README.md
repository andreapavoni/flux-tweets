# Real Time Twitter Stream with Node and React


This is a fork of the [code repository](https://github.com/scotch-io/react-tweets) for the awesome tutorial by @kenwheeler: [Build A Real-Time Twitter Stream with Node and React.js](http://scotch.io/tutorials/javascript/build-a-real-time-twitter-stream-with-node-and-react-js). I've tinkered a bit with this code:

* CoffeeScript instead of plain JS
* [ReactJS](http://facebook.github.io/react/)  >= 0.12
* [Flux](http://facebook.github.io/flux/)
* various refactorings

## Requirements

* nodejs
* npm
* mongodb

## How to Use

1. Clone this repository: `git clone git@github.com:apeacox/flux-tweets`
2. Go into folder: `cd flux-tweets`
3. Install dependencies: `npm install`
4. Create a `.env` file and put credentials for Twitter API (see `config.coffee` for the variable names)
5. Start the app: `npm start`
6. View in browser at: `http://localhost:8080`
7. Tweet away!
