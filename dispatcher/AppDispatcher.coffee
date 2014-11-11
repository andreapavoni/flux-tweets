Dispatcher = require("flux").Dispatcher

# Create dispatcher instance
AppDispatcher = new Dispatcher()

# Convenience method to handle dispatch requests
AppDispatcher.handleAction = (action) ->
  @dispatch
    source: "SERVER_ACTION"
    action: action

module.exports = AppDispatcher
