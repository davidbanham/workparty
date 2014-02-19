var gulp = require('gulp');
var gutil = require('gulp-util');

var browserify = require('gulp-browserify');
var coffee = require('gulp-coffee');

var spawn = require('child_process').spawn
var fs = require('fs')

var paths = {
  scripts: ['src/coffee/*.coffee']
}

gulp.task('scripts', function() {
  gulp.src('src/coffee/app.coffee', {read: false})
  .pipe(browserify({
    transform: ['coffeeify'],
    shim: {
      headtrackr: {
        path: 'src/js/vendor/headtrackr.js',
        exports: 'headtrackr'
      }
    },
    extensions: ['.coffee']
  }))
  .pipe(gulp.dest('build/js'))
});

gulp.task('getrealmad', function() {
  var shell = spawn('browserify', ['src/coffee/app.coffee'], {cwd: process.cwd()}).stdout
  .pipe(fs.createWriteStream('build/js/app.js'));
});

gulp.task('watch', function() {
  gulp.watch(paths.scripts, ['getrealmad']);
});

