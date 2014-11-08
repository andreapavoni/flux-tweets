React = require("react")
Tweet = require("./Tweet.react")

# Render our tweets
module.exports = Tweets = React.createClass(
  render: ->
    # Build list items of single tweet components using map
    content = @props.tweets.map (tweet) ->
      <Tweet key={tweet.twid} tweet={tweet} />

    # Return ul filled with our mapped tweets
    <ul className="tweets">{content}</ul>
)

