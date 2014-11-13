# Require our dependencies
express = require("express")
exphbs = require("express-handlebars")
http = require("http")
ntwitter = require("ntwitter")
favicon = require("serve-favicon")
compress = require("compression")()

config = require("../config")
routes = require("./routes")
streamHandler = require("./utils/streamHandler")

app = express()

# Set handlebars as the templating engine
viewsPath = "#{__dirname}/views"
hbsConfig =
  defaultLayout: "main"
  layoutsDir: "#{viewsPath}/layouts/"
  partialsDir: viewsPath

app.set('views', viewsPath)
app.engine "handlebars", exphbs(hbsConfig)
app.set "view engine", "handlebars"

# Disable etag headers on responses
app.disable "etag"
# Enable gzip compression
app.use compress
# Serve favicon
app.use favicon("#{__dirname}/../public/favicon.ico")
# Set /public as our static content dir
app.use "/", express.static("#{__dirname}/../public/")

# Routes
app.get "/", routes.index
app.get "/page/:page/:skip", routes.page

# Initialize http server
server = http.createServer(app).listen(config.port, ->
  console.log "Express server listening on port #{server.address().port}"
)

# Initialize socket.io
io = require("socket.io").listen(server)

# Create a new ntwitter instance
twit = new ntwitter(config.twitter)

# Set a stream listener for tweets matching tracking keywords
twit.stream "statuses/filter", {track: config.keywordsTrack}, (stream) ->
  streamHandler stream, io

