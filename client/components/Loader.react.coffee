React = require('react')

module.exports = Loader = React.createClass(
  render: ->
    className = "loader#{ if @props.paging then ' active' else '' }"

    return (
      <div className={className}>
        <img src="svg/loader.svg" width='32px' height='32px' />
      </div>
    )
)
