React = require('react')
TweetsActions = require('../actions/TweetsActions')

module.exports = NotificationBar = React.createClass(
  render: ->
    count = @props.count
    className = "notification-bar#{ if count > 0 then ' active' else '' }"

    return (
      <div className={className}>
        <p>There are {count} new tweets! <a href="#top" onClick={TweetsActions.showNewTweets}>Click here to see them.</a></p>
      </div>
    )
)
