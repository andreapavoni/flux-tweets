# Real Time Twitter Stream with Node and React

This is a fork of the [code repository](https://github.com/scotch-io/react-tweets) for the awesome tutorial by @kenwheeler: [Build A Real-Time Twitter Stream with Node and React.js](http://scotch.io/tutorials/javascript/build-a-real-time-twitter-stream-with-node-and-react-js). I've tinkered a bit with this code:

* CoffeeScript instead of plain JS
* [ReactJS](http://facebook.github.io/react/)  >= 0.12
* [Flux](http://facebook.github.io/flux/)
* various refactorings

## Requirements

* nodejs
* npm
* redis

## Live Demo

I've put a [live demo on heroku](http://flux-tweets.herokuapp.com)

## How to Use

1. Clone this repository: `git clone git@github.com:apeacox/flux-tweets`
2. Go into folder: `cd flux-tweets`
3. Install dependencies: `npm install`
4. Edit `.env.sample` and put credentials for Twitter API, save it as `.env`
5. Start redis server
6. Start the app with `npm start` (or `gulp dev` if you want to tinker)
7. View in browser at: `http://localhost:8080`
8. Tweet away!
