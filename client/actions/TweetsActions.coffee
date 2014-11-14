AppDispatcher = require("../dispatcher/AppDispatcher")
TweetsConstants = require("../constants/TweetsConstants")

# Define actions object
module.exports = TweetsActions =

  # Load paged tweets from the server
  loadPage: (page) ->
    AppDispatcher.handleAction
      actionType: TweetsConstants.LOAD_PAGE
      page: page

  # Add tweet to store
  addTweet: (tweet) ->
    AppDispatcher.handleAction
      actionType: TweetsConstants.ADD_TWEET
      tweet: tweet

  # Show new tweets
  showNewTweets: ->
    AppDispatcher.handleAction
      actionType: TweetsConstants.SHOW_NEW_TWEETS
