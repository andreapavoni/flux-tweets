# Require our dependencies
config = require("./config")
express = require("express")
exphbs = require("express-handlebars")
http = require("http")
mongoose = require("mongoose")
ntwitter = require("ntwitter")

routes = require("./routes")
streamHandler = require("./utils/streamHandler")

# Create an express instance
app = express()

# Set handlebars as the templating engine
app.engine "handlebars", exphbs(defaultLayout: "main")
app.set "view engine", "handlebars"

# Disable etag headers on responses
app.disable "etag"

# Connect to our mongo database
mongoose.connect config.mongodbUrl, (err, res) ->
  if err
    console.log "MONGODB ERROR connecting to #{config.mongodbUrl}: #{err} "

# Routes
app.get "/", routes.index
app.get "/page/:page/:skip", routes.page

# Set /public as our static content dir
app.use "/", express.static(__dirname + "/public/")

# Initialize http server
server = http.createServer(app)

# Initialize socket.io
io = require("socket.io").listen(server)

# Create a new ntwitter instance
twit = new ntwitter(config.twitter)

# Set a stream listener for tweets matching tracking keywords
twit.stream "statuses/filter", {track: config.keywordsTrack}, (stream) ->
  streamHandler stream, io

module.exports = server
