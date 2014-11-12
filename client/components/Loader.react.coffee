React = require('react')

module.exports = Loader = React.createClass(
  render: ->
    className = "loader#{ if @props.paging then ' active' else '' }"

    return (
      <div className={className}>
        <img src="svg/loader.svg" />
      </div>
    )
)
