AppDispatcher = require("../dispatcher/AppDispatcher")
EventEmitter = require("events").EventEmitter
TweetsConstants = require("../constants/TweetsConstants")
assign = require('object-assign')

CHANGE_EVENT='change'

_currentState =
  tweets: []
  count: 0
  page: 0
  paging: false
  skip: 0
  done: false

addTweet = (tweet) ->
  # Add tweet to head of tweets
  _currentState.tweets.unshift tweet

  TweetStore.setState
    skip: _currentState.skip + 1 # Increment the skip count
    count: _currentState.count + 1 # Increment the unread count
    tweets: _currentState.tweets


# Get JSON from server by page
loadPage = (page) ->
  # Set application state (Paging, Increment page)
  TweetStore.setState({page: page, paging: true})

  # Setup our ajax request
  request = new XMLHttpRequest()
  request.open "GET", "page/#{page}/#{_currentState.skip}", true

  request.onload = ->
    # If everything is cool...
    reqOk = request.status >= 200 and request.status < 400
    if reqOk && (tweets = JSON.parse(request.responseText)).length > 0
      # Push them onto the end of the current tweets array
      updated = _currentState.tweets
      tweets.forEach (tweet) ->
        updated.push tweet

      # This app is so fast, I actually use a timeout for dramatic effect
      # Otherwise you'd never see our super sexy loader svg
      window.setTimeout (->
        TweetStore.setState({tweets: updated, done: true, paging: false})
      ), 2500
    else
      # Paging complete, not paging
      TweetStore.setState({done: true, paging: false})

  request.send()


# Show the unread tweets
showNewTweets = ->
  # Get current application state
  updated = _currentState.tweets

  # Mark our tweets active
  updated.forEach (tweet) ->
    tweet.active = true

  # Set application state (active tweets + reset unread count)
  TweetStore.setState({tweets: updated, count: 0})

# Extend TweetStore with EventEmitter to add eventing capabilities
TweetStore = assign({}, EventEmitter::,
  getState: ->
    _currentState

  setState: (obj) ->
    _currentState = assign(_currentState, obj)
    @emitChange()
    _currentState

  # Emit Change event
  emitChange: ->
    @emit CHANGE_EVENT

  # Add change listener
  addChangeListener: (callback) ->
    @on CHANGE_EVENT, callback

  # Remove change listener
  removeChangeListener: (callback) ->
    @removeListener CHANGE_EVENT, callback
)

# Register callback with AppDispatcher
AppDispatcher.register (payload) ->
  action = payload.action

  # Respond to actions
  switch action.actionType
    when TweetsConstants.ADD_TWEET
      addTweet(action.tweet)
    when TweetsConstants.SHOW_NEW_TWEETS
      showNewTweets()
    when TweetsConstants.LOAD_PAGE
      loadPage(action.page)
    else
      return true

  # If action was responded to, emit change event
  TweetStore.emitChange()
  true

module.exports = TweetStore
