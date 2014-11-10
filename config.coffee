dotenv = require('dotenv')
dotenv.load()

module.exports =
  port: process.env.PORT or 8080
  mongodbUrl: process.env.MONGOLAB_URI or process.env.MONGOHQ_URL or "mongodb://localhost/flux-tweets"
  twitter:
    consumer_key: process.env.TWITTER_KEY
    consumer_secret: process.env.TWITTER_SECRET
    access_token_key: process.env.TWITTER_TOKEN_KEY
    access_token_secret: process.env.TWITTER_TOKEN_SECRET
