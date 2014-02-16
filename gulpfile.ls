require! {
  gulp
  fs
  'gulp-livescript'
  'gulp-header'
  'gulp-conventional-changelog'
  'gulp-bump'
  'gulp-mocha'
  'gulp-git'
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

gulp.task 'compile' <[ compile:test compile:src ]>

gulp.task 'compile:test' ->
  gulp.src 'test/*.ls' ->
    .pipe gulp-livescript bare: true
    .pipe gulp.dest './build/test'

gulp.task 'compile:src' ->
  gulp.src 'src/*.ls' ->
    .pipe gulp-livescript bare: true
    .pipe gulp.dest './build/src'

gulp.task 'test:mocha' <[ compile ]> ->
  gulp.src 'build/test/*.js'
    .pipe gulp-mocha!

gulp.task 'release:bump' ->
  gulp.src 'package.json' ->
    .pipe gulp-bump type: 'patch'
    .pipe gulp.dest('.')

gulp.task 'release:build' <[ compile ]> ->
  gulp.src 'tmp/app.js'
    .pipe getHeaderStream!
    .pipe gulp.dest('./dist')

gulp.task 'release:changelog' ->
  gulp.src 'CHANGELOG.md'
    .pipe gulpConventionalChangelog!
    .pipe gulp.dest '.'

gulp.task 'release:commit' ->
  const jsonFile = getJsonFile!
  const message  = "release: v#{ jsonFile.version }"
  gulp.src <[ package.json CHANGELOG.md ]>
    .pipe gulp-git.add!
    .pipe gulp-git.commit message
    .pipe gulp-git.tag("v#{jsonFile.version}" message)

gulp.task 'release' <[ release:commit ]>
gulp.task 'test' <[ test:mocha ]>
