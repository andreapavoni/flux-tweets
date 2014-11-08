Tweet = require("../models/Tweet")

module.exports = (stream, io) ->
  stream.on "error", (err, code) ->
    console.log "STREAM ERROR: #{err} #{code}"

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

    # Create a new model instance with our object
    tweetEntry = new Tweet(tweet)

    # Save 'er to the database
    tweetEntry.save (err) ->
      # If everything is cool, socket.io emits the tweet.
      io.emit "tweet", tweet  unless err
