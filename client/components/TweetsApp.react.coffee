React = require("react")
TweetStore = require("../stores/TweetStore")
Timeline = require("./Timeline.react")
Loader = require("./Loader.react")
NotificationBar = require("./NotificationBar.react")
TweetsActions = require('../actions/TweetsActions')
io = require('socket.io-client')

module.exports = TweetsApp = React.createClass(
  # Set the initial component state
  getInitialState: ->
    # Set initial application state using props
    TweetStore.setState(tweets: @props.tweets)

  # Called directly after component rendering, only on client
  componentDidMount: ->
    TweetStore.addChangeListener(@_onChange)

    # Init socket.io and listen to new tweets
    socket = io.connect()
    socket.on "tweet", (data) ->
      TweetsActions.addTweet data

    window.addEventListener "scroll", @_onWindowScroll

  componentWillUnmount: ->
    TweetStore.removeChangeListener(@_onChange)
    window.removeEventListener "scroll", @_onWindowScroll

  _onChange: ->
    @setState TweetStore.getState()

  _onWindowScroll: ->
    # Get scroll pos & window data
    h = (window.innerHeight or document.documentElement.clientHeight or 0)
    s = (document.body.scrollTop or document.documentElement.scrollTop or 0)

    # Check if window has scrolled
    scrolled = (h + s) > document.body.offsetHeight

    # If scrolled enough, not currently paging and not complete...
    if scrolled && !(@state.paging && @state.done)
      # Call action: load next page
      TweetsActions.loadPage(@state.page + 1)

  # Render the component
  render: ->
    return(
      <div className="tweets-app">
        <Timeline tweets={@state.tweets} />
        <Loader paging={@state.paging} />
        <NotificationBar count={@state.count} />
      </div>
    )
)
