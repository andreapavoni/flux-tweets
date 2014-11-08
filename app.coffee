React = require("react")
TweetsApp = require("./components/TweetsApp.react")

# Snag the initial state that was passed from the server side
initialState = JSON.parse(document.getElementById("initial-state").innerHTML)

# Render the components, picking up where react left off on the server
React.render(
  <TweetsApp tweets={initialState}/>,
  document.getElementById("react-app")
)
