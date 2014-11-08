React = require('react')

module.exports = NotificationBar = React.createClass(
  render: ->
    count = @props.count
    className = "notification-bar#{ if count > 0 then ' active' else '' }"

    return (
      <div className={className}>
        <p>There are {count} new tweets! <a href="#top" onClick={this.props.onShowNewTweets}>Click here to see them.</a></p>
      </div>
    )
)
