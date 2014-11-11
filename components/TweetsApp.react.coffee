React = require("react")
TweetStore = require("../stores/TweetStore")
Timeline = require("./Timeline.react")
Loader = require("./Loader.react")
NotificationBar = require("./NotificationBar.react")
TweetsActions = require('../actions/TweetsActions')

getTweetsState = (tweets) ->
  # Set initial application state using props
  tweets: tweets or TweetStore.getTweets()
  count: TweetStore.getTweetsCount()
  page: TweetStore.getPage()
  paging: TweetStore.isPaging()
  skip: TweetStore.getSkip()
  done: TweetStore.isDone()

module.exports = TweetsApp = React.createClass(

  # Set the initial component state
  getInitialState: ->
    getTweetsState(@props.tweets)

  # Called directly after component rendering, only on client
  componentDidMount: ->
    TweetStore.addChangeListener(@_onChange)

    # Init socket.io and listen to new tweets
    socket = io.connect()
    socket.on "tweet", (data) ->
      TweetsActions.addTweet data

    TweetStore.checkWindowScroll()

  componentWillUnmount: ->
    TweetStore.removeChangeListener(@_onChange)

  _onChange: ->
    @setState getTweetsState()

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
