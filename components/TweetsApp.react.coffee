React = require("react")
Tweets = require("./Tweets.react")
Loader = require("./Loader.react")
NotificationBar = require("./NotificationBar.react")

module.exports = TweetsApp = React.createClass(
  # Add a tweet to our timeline
  addTweet: (tweet) ->
    # Get current application state
    updated = @state.tweets

    # Increment the unread count
    count = @state.count + 1

    # Increment the skip count
    skip = @state.skip + 1

    # Add tweet to the beginning of the tweets array
    updated.unshift tweet

    # Set application state
    @setState
      tweets: updated
      count: count
      skip: skip

  # Get JSON from server by page
  getPage: (page) ->
    # Setup our ajax request
    request = new XMLHttpRequest()
    self = this
    request.open "GET", "page/" + page + "/" + @state.skip, true
    request.onload = ->
      # If everything is cool...
      if request.status >= 200 and request.status < 400
        # Load our next page
        self.loadPagedTweets JSON.parse(request.responseText)
      else
        # Set application state (Not paging, paging complete)
        self.setState
          paging: false
          done: true

    # Fire!
    request.send()


  # Show the unread tweets
  showNewTweets: ->
    # Get current application state
    updated = @state.tweets

    # Mark our tweets active
    updated.forEach (tweet) ->
      tweet.active = true

    # Set application state (active tweets + reset unread count)
    @setState
      tweets: updated
      count: 0


  # Load tweets fetched from the server
  loadPagedTweets: (tweets) ->
    self = @

    # If we still have tweets...
    if tweets.length > 0
      # Get current application state
      updated = @state.tweets

      # Push them onto the end of the current tweets array
      tweets.forEach (tweet) ->
        updated.push tweet

      # This app is so fast, I actually use a timeout for dramatic effect
      # Otherwise you'd never see our super sexy loader svg
      setTimeout (->
        # Set application state (Not paging, add tweets)
        self.setState
          tweets: updated
          paging: false
      ), 1000
    else
      # Set application state (Not paging, paging complete)
      @setState
        done: true
        paging: false


  # Check if more tweets should be loaded, by scroll position
  checkWindowScroll: ->
    # Get scroll pos & window data
    h = Math.max(document.documentElement.clientHeight, window.innerHeight or 0)
    s = (document.body.scrollTop or document.documentElement.scrollTop or 0)
    scrolled = (h + s) > document.body.offsetHeight

    # If scrolled enough, not currently paging and not complete...
    if scrolled and not @state.paging and not @state.done
      # Set application state (Paging, Increment page)
      @setState
        paging: true
        page: @state.page + 1

      # Get the next page of tweets from the server
      @getPage @state.page


  # Set the initial component state
  getInitialState: (props) ->
    props = props or @props

    # Set initial application state using props
    tweets: props.tweets
    count: 0
    page: 0
    paging: false
    skip: 0
    done: false

  componentWillReceiveProps: (newProps, oldProps) ->
    @setState @getInitialState(newProps)


  # Called directly after component rendering, only on client
  componentDidMount: ->
    # Preserve self reference
    self = @

    # Initialize socket.io
    socket = io.connect()

    # On tweet event emission...
    socket.on "tweet", (data) ->
      # Add a tweet to our queue
      self.addTweet data

    # Attach scroll event to the window for infinity paging
    window.addEventListener "scroll", @checkWindowScroll


  # Render the component
  render: ->
    return(
      <div className="tweets-app">
        <Tweets tweets={this.state.tweets} />
        <Loader paging={this.state.paging}/>
        <NotificationBar count={this.state.count} onShowNewTweets={this.showNewTweets}/>
      </div>
    )
)
