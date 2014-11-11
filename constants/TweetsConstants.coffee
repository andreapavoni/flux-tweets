keyMirror = require("react/lib/keyMirror")

# Define action constants
module.exports = keyMirror(
  SHOW_NEW_TWEETS: null # Show the unread tweets
  LOAD_PAGE: null # Get JSON from server by page
  LOAD_TWEETS: null # Loads data from server
  LOAD_PAGED_TWEETS: null # Loads data from server
  TWEET_ADD: null # Adds tweet to timeline
)
