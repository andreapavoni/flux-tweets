React = require('react')

module.exports = Tweet = React.createClass(
  render: ->
    tweet = @props.tweet
    className = "tweet#{ if tweet.active then ' active' else '' }"

    return (
      <li className={className}>
        <img src={tweet.avatar} className="avatar" width='32px' height='32px' />
        <blockquote>
          <cite>
            <a href={"http://www.twitter.com/" + tweet.screenname}>{tweet.author}</a>
            <span className="screen-name">@{tweet.screenname}</span>
          </cite>
          <span className="content">{tweet.body}</span>
        </blockquote>
      </li>
    )
)
