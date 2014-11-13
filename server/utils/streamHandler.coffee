Tweet = require("../models/Tweet")

module.exports = (stream, io) ->
  stream.on "error", (err, code) ->
    console.log "TWITTER STREAM ERROR: #{err} #{code}"

  # When tweets get sent our way ...
  stream.on "data", (data) ->
    # Construct a new tweet object
    tweet =
      twid: data["id"]
      active: false
      author: data["user"]["name"]
      avatar: data["user"]["profile_image_url"]
      body: data["text"]
      date: data["created_at"]
      screenname: data["user"]["screen_name"]

    # Save 'er to the database
    Tweet.create tweet, (err, res) ->
      # If everything is cool, socket.io emits the tweet.
      io.emit "tweet", tweet  unless err
