var gulp = require('gulp');
var gutil = require('gulp-util');

var browserify = require('gulp-browserify');
var coffee = require('gulp-coffee');

var paths = {
  scripts: ['src/coffee/*.coffee']
}

gulp.task('scripts', function() {
  gulp.src(paths.scripts)
  .pipe(coffee({bare: true}).on('error', gutil.log))
  .pipe(browserify())
  .pipe(gulp.dest('build/js'))
});

gulp.task('watch', function() {
  gulp.watch(paths.scripts, ['scripts']);
});

