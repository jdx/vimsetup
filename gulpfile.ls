require! {
  gulp
  fs
  'gulp-livescript'
  'gulp-header'
  'gulp-conventional-changelog'
  'gulp-bump'
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

gulp.task 'release:bump' '' ->
  gulp.src 'package.json' ->
    .pipe gulp-bump type: 'patch'
    .pipe gulp.dest('.')

gulp.task 'release:build' <[ release:bump ]> ->
  gulp.src './src/app.ls'
    .pipe gulp-livescript!
    .pipe getHeaderStream!
    .pipe gulp.dest('./dist')

gulp.task 'release:commit' <[ release:build ]> ->
  const jsonFile = getJsonFile!
  const commitMsg = "release: v#{ jsonFile.version }"
  gulp.src <[ package.json CHANGELOG.md ]>
    .pipe gulpConventionalChangelog!
    .pipe gulp.dest('.')

gulp.task 'release' <[ release:commit ]>
