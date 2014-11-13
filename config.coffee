dotenv = require('dotenv')
dotenv.load()

module.exports =
  port: process.env.PORT or 8080
  redis:
    url: process.env.REDIS_URL or process.env.REDISTOGO_URL or "redis://localhost:6379"
    limit: 5000 # limit the number of total tweets stored
  keywordsTrack: 'javascript' # comma separated!
  twitter:
    consumer_key: process.env.TWITTER_KEY
    consumer_secret: process.env.TWITTER_SECRET
    access_token_key: process.env.TWITTER_TOKEN_KEY
    access_token_secret: process.env.TWITTER_TOKEN_SECRET
