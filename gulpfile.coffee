gulp = require("gulp")
gutil = require("gulp-util")
browserify = require('gulp-browserify')
rename = require("gulp-rename")
uglify = require("gulp-uglify")
size = require("gulp-size")

gulp.task 'build', ->
  gulp.src('./client/app.coffee', { read: false })
    .pipe(browserify(
      transform: ['coffee-reactify']
      extensions: ['.coffee']
    ))
    .pipe(rename('bundle.js'))
    .pipe(gulp.dest('./public/js'))
    .pipe(size showFiles: true, title: "Plain JS")
    .on("error", gutil.log)
    .pipe(uglify())
    .pipe(rename("bundle.min.js"))
    .pipe(gulp.dest("./public/js"))
    .pipe(size showFiles: true, title: "Minified JS")
    .on("error", gutil.log)

gulp.task "default", ["build"]
