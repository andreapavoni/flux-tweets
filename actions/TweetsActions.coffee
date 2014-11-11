AppDispatcher = require("../dispatcher/AppDispatcher")
TweetsConstants = require("../constants/TweetsConstants")

# Define actions object
module.exports = TweetsActions =

  # Receive tweets data from websockets
  loadTweets: (tweets) ->
    AppDispatcher.handleAction
      actionType: TweetsConstants.LOAD_TWEETS
      tweets: tweets

  # Load tweets fetched from the server
  loadPagedTweets: (tweets) ->
    AppDispatcher.handleAction
      actionType: TweetsConstants.LOAD_PAGED_TWEETS
      tweets: tweets

  # Add tweet to store
  addTweet: (tweet) ->
    AppDispatcher.handleAction
      actionType: TweetsConstants.TWEET_ADD
      tweet: tweet

  # Get JSON from server by page
  loadPage: (page) ->
    AppDispatcher.handleAction
      actionType: TweetsConstants.LOAD_PAGE
      page: page

  # Show new tweets
  showNewTweets: ->
    AppDispatcher.handleAction
      actionType: TweetsConstants.SHOW_NEW_TWEETS
