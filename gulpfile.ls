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
  'gulp-rename'
  'gulp-nodemon'
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
      files.pipe(gulp-mocha(mocha-options))
        .on 'error', (err) -> this.emit('end')

gulp.task 'release:bump' ->
  gulp.src 'package.json' ->
    .pipe gulp-bump type: 'patch'
    .pipe gulp.dest('.')

gulp.task 'clean' ->
  gulp.src 'public', read: false
    .pipe gulp-clean!

gulp.task 'build' <[ clean ]> ->
  gulp.src 'src/*.ls'
    .pipe gulp-livescript bare: true
    .pipe getHeaderStream!
    .pipe gulp-uglify preserveComments: 'some'
    .pipe gulp-rename extname: '.min.js'
    .pipe gulp.dest('./public')

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
gulp.task 'dev' <[ test:watch server ]>
