require! {
  gulp
  fs
  'gulp-livescript'
  'gulp-header'
  'gulp-conventional-changelog'
  'gulp-bump'
  'gulp-mocha'
  'gulp-git'
  'gulp-watch'
  'gulp-clean'
  'gulp-uglify'
  'gulp-plumber'
  'gulp-concat'
  'gulp-nodemon'
  'gulp-livereload'
  'gulp-exec'
}

function getJsonFile
  fs.readFileSync './package.json', 'utf-8' |> JSON.parse

function getHeaderStream
  const jsonFile = getJsonFile!
  const date = new Date

  gulp-header """
/*! #{ jsonFile.name } - v#{ jsonFile.version } - #{ date }
 *  #{ jsonFile.link }
 *  Copyright © #{ date.getFullYear! } #{ jsonFile.author.name } #{ jsonFile.author.url }
 *  Licensed #{ jsonFile.license.type } #{ jsonFile.license.url }
 */\n\n
"""

mocha-options = {
  reporter: 'spec'
  globals: should: require('should')
}

gulp.task 'test' ->
  gulp.src 'test/*.ls'
    .pipe gulp-mocha mocha-options
    .on 'error', (err) -> this.emit('end')

gulp.task 'test:watch' ->
  gulp.src 'test/*.ls', read: false
    .pipe gulp-watch emit: 'all', (files) ->
      files
        .pipe(gulp-mocha(mocha-options))
        .on 'error', (err) -> this.emit('end')

gulp.task 'src:watch' ->
  gulp.src 'src/**',
    .pipe gulp-watch!
    .pipe gulp-exec 'browserify src/router.ls -t liveify -t hbsfy -d --extension=.ls -o ./public/app.min.js'

gulp.task 'livereload' ->
  server = gulp-livereload();
  gulp.watch 'public/app.min.js'
    .on 'change' (file) ->
      server.changed file.path

gulp.task 'release:bump' ->
  gulp.src 'package.json' ->
    .pipe gulp-bump type: 'patch'
    .pipe gulp.dest('.')

gulp.task 'clean' ->
  gulp.src <[ public ]>, read: false
    .pipe gulp-clean!

gulp.task 'vendor' <[ clean ]> ->
  gulp.src 'vendor/**'
    .pipe gulp.dest('public/vendor')

gulp.task 'build' <[ vendor ]> ->
  gulp.src 'src/router.ls'
    .pipe gulp-exec 'browserify src/router.ls -t liveify -t hbsfy -d --extension=.ls -o ./public/app.min.js'

gulp.task 'release:changelog' <[ release:bump ]> ->
  gulp.src 'CHANGELOG.md'
    .pipe gulpConventionalChangelog!
    .pipe gulp.dest '.'

gulp.task 'release:commit' <[ build release:changelog ]> ->
  const jsonFile = getJsonFile!
  const message  = "release: v#{ jsonFile.version }"
  gulp.src <[ package.json CHANGELOG.md ]>
    .pipe gulp-git.add!
    .pipe gulp-git.commit message
    .pipe gulp-git.tag("v#{jsonFile.version}" message)

gulp.task 'server' <[ build ]> ->
  gulp-nodemon {
    script: 'server.ls'
  }

gulp.task 'release' <[ release:commit ]>
gulp.task 'dev' <[ src:watch test:watch server livereload ]>
