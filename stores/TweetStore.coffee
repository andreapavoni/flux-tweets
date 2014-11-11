AppDispatcher = require("../dispatcher/AppDispatcher")
EventEmitter = require("events").EventEmitter
TweetsConstants = require("../constants/TweetsConstants")
_ = require('underscore')

_tweets = []
_count = 0
_page = 0
_paging = false
_skip = 0
_done = false

loadTweets = (tweets) ->
  _tweets = tweets

addTweet = (tweet) ->
  console.log "called addTweet in store: #{JSON.stringify(tweet)}"
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
      loadPagedTweets JSON.parse(request.responseText)
    else
      # Set application state (Not paging, paging complete)
      _paging = false
      _done = true
  request.send()


# Load tweets fetched from the server
loadPagedTweets = (tweets) ->
  # If we still have tweets...
  if tweets.length > 0
    # Get current application state
    updated = _tweets

    # Push them onto the end of the current tweets array
    tweets.forEach (tweet) ->
      updated.push tweet

    # This app is so fast, I actually use a timeout for dramatic effect
    # Otherwise you'd never see our super sexy loader svg
    setTimeout (->
      # Set application state (Not paging, add tweets)
      _tweets = updated
      _paging = false
    ), 1000
  else
    # Set application state (Not paging, paging complete)
    _done = true
    _paging = false


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


# Check if more tweets should be loaded, by scroll position
onWindowScroll = ->
  # Get scroll pos & window data
  h = Math.max(document.documentElement.clientHeight, window.innerHeight or 0)
  s = (document.body.scrollTop or document.documentElement.scrollTop or 0)
  scrolled = (h + s) > document.body.offsetHeight

  # If scrolled enough, not currently paging and not complete...
  if scrolled and not _paging and not _done
    # Set application state (Paging, Increment page)
    _paging = true
    _page = _page + 1

    # Get the next page of tweets from the server
    loadPage _page


# Extend TweetStore with EventEmitter to add eventing capabilities
TweetStore = _.extend({}, EventEmitter::,
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

  # Attach scroll event to the window for infinity paging
  checkWindowScroll: ->
    window.addEventListener "scroll", onWindowScroll

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
    when TweetsConstants.LOAD_PAGED_TWEETS
      loadPagedTweets(action.data)
    when TweetsConstants.LOAD_TWEETS
      loadTweets(action.data)
    when TweetsConstants.LOAD_PAGE
     loadPage(action.data)
    when TweetsConstants.TWEET_ADD
      addTweet(action.tweet)
    when TweetsConstants.SHOW_NEW_TWEETS
      showNewTweets()
    else
      return true

  # If action was responded to, emit change event
  TweetStore.emitChange()
  true

module.exports = TweetStore
