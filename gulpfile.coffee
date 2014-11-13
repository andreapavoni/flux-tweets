gulp = require("gulp")
gutil = require("gulp-util")
browserify = require("gulp-browserify")
nodemon = require("gulp-nodemon")
rename = require("gulp-rename")
uglify = require("gulp-uglify")
size = require("gulp-size")

DEST='./public'
JS_BUNDLE='bundle'

gulp.task 'build', ->
  gulp.src('./client/app.coffee', { read: false })
    .pipe(browserify(
      transform: ['coffee-reactify']
      extensions: ['.coffee']
    ))
    .on("error", gutil.log)
    .pipe(rename("#{JS_BUNDLE}.js"))
    .pipe gulp.dest("#{DEST}/js")
    .pipe(size showFiles: true, title: "Plain JS")

gulp.task 'dist', ['build'], ->
  gulp.src("#{DEST}/js/#{JS_BUNDLE}.js")
    .pipe(uglify())
    .pipe(rename("#{JS_BUNDLE}.min.js"))
    .pipe(gulp.dest("#{DEST}/js"))
    .pipe(size showFiles: true, title: "Minified JS")
    .on("error", gutil.log)

gulp.task "watch", ->
  gulp.watch "client/**/*.coffee", ['build']

gulp.task "dev", ['watch'], ->
  nodemon(
    script: "./server/app.coffee"
    ext: "coffee"
  )

gulp.task "default", ["build"]
