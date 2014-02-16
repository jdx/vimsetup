var gulp = require('gulp');
var gutil = require('gulp-util');
var liveScript = require('gulp-livescript');
var uglify = require('gulp-uglify');
var concat = require('gulp-concat');

gulp.task('default', ['scripts']);

gulp.task('scripts', function() {
  gulp.src('./scripts/*.ls')
    .pipe(liveScript({bare: true}).on('error', gutil.log))
    .pipe(uglify())
    .pipe(concat('application.js'))
    .pipe(gulp.dest('./dist'));
});
