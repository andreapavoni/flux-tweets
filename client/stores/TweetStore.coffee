AppDispatcher = require("../dispatcher/AppDispatcher")
EventEmitter = require("events").EventEmitter
TweetsConstants = require("../constants/TweetsConstants")
assign = require('object-assign')

_tweets = []
_count = 0
_page = 0
_paging = false
_skip = 0
_done = false

addTweet = (tweet) ->
  # Increment the unread count
  _count = _count + 1
  # Increment the skip count
  _skip = _skip + 1
  # Add tweet to the beginning of the tweets array
  _tweets.unshift tweet


# Get JSON from server by page
loadPage = (page) ->
  # Setup our ajax request
  request = new XMLHttpRequest()
  request.open "GET", "page/#{page}/#{_skip}", true

  request.onload = ->
    # If everything is cool...
    if request.status >= 200 and request.status < 400
      # Load our next page
      tweets = JSON.parse(request.responseText)

      # If we still have tweets...
      if tweets.length > 0
        # Push them onto the end of the current tweets array
        updated = _tweets
        tweets.forEach (tweet) ->
          updated.push tweet

        # This app is so fast, I actually use a timeout for dramatic effect
        # Otherwise you'd never see our super sexy loader svg
        setTimeout (->
          # Update tweets
          _tweets = updated
          # Paging completed
          _paging = false
        ), 1500
      else
        # Paging complete
        _done = true
        _paging = false
    else
      # Set application state (Not paging, paging complete)
      _paging = false
      _done = true
  request.send()


# Show the unread tweets
showNewTweets = ->
  # Get current application state
  updated = _tweets

  # Mark our tweets active
  updated.forEach (tweet) ->
    tweet.active = true

  # Set application state (active tweets + reset unread count)
  _tweets = updated
  _count = 0


loadPagedTweets = (scrolled) ->
  # If scrolled enough, not currently paging and not complete...
  if scrolled and not _paging and not _done
    # Set application state (Paging, Increment page)
    _paging = true
    _page = _page + 1

    # Get the next page of tweets from the server
    loadPage _page


# Extend TweetStore with EventEmitter to add eventing capabilities
TweetStore = assign({}, EventEmitter::,
  getTweets: ->
    _tweets

  getTweetsCount: ->
    _count

  getPage: ->
    _page

  isPaging: ->
    _paging

  isDone: ->
    _done

  getSkip: ->
    _skip

  # Emit Change event
  emitChange: ->
    @emit "change"

  # Add change listener
  addChangeListener: (callback) ->
    @on "change", callback

  # Remove change listener
  removeChangeListener: (callback) ->
    @removeListener "change", callback
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
    when TweetsConstants.LOAD_PAGED_TWEETS
      loadPagedTweets(action.scrolled)
    else
      return true

  # If action was responded to, emit change event
  TweetStore.emitChange()
  true

module.exports = TweetStore
