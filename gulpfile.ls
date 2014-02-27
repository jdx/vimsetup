require! {
  gulp
  fs
  'gulp-livescript'
  'gulp-mocha'
  'gulp-clean'
  'gulp-uglify'
  'gulp-plumber'
  'gulp-concat'
  'gulp-nodemon'
}

mocha-options = {
  reporter: 'spec'
  globals: should: require('should')
}

gulp.task 'test' ->
  gulp.src 'test/*.ls'
    .pipe gulp-mocha mocha-options
    .on 'error', (err) -> this.emit('end')

gulp.task 'watch' ->
  gulp.watch 'src/**/*.ls', (file) ->
    gulp.src file.path
      .pipe gulp-plumber!
      .pipe gulp-livescript bare: true
      .pipe gulp.dest './public'

gulp.task 'clean' ->
  gulp.src <[ public ]>, read: false
    .pipe gulp-clean!

gulp.task 'templates' <[ clean ]> ->
  gulp.src 'templates/**/*.html'
    .pipe gulp.dest('public/pages')

gulp.task 'livescript' <[ clean ]> ->
  gulp.src 'src/**/*.ls'
    .pipe gulp-livescript bare: true
    .pipe gulp.dest './public'

gulp.task 'server' <[ build ]> ->
  gulp-nodemon {
    script: 'server.ls'
  }

gulp.task 'build'   <[ clean templates livescript ]>
gulp.task 'default' <[ build watch server ]>
