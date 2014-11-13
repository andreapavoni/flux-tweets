coffeeReact = require('coffee-react/register')
React = require('react')
TweetsApp = React.createFactory require('../client/components/TweetsApp.react')
Tweet = require("./models/Tweet")

module.exports =
  index: (req, res) ->
    # Call static model method to get tweets in the db
    Tweet.getTweets 0, 0, (tweets, pages) ->
      # Render React to a string, passing in our fetched tweets
      markup = React.renderToString(TweetsApp(tweets: tweets))

      # Render our 'home' template
      res.render "home",
        markup: markup # Pass rendered react markup
        state: JSON.stringify(tweets) # Pass current state to client side
        productionEnv: process.env.NODE_ENV == 'production'

  page: (req, res) ->
    # Fetch tweets by page via param
    Tweet.getTweets req.params.page, req.params.skip, (tweets) ->
      # Render as JSON
      res.send tweets
