var gulp = require('gulp');

gulp.task('build', function(){
    return gulp.src(['mod/**/*.+(lua|tex|xml|zip)', '!mod/exported/**'])
      .pipe(gulp.dest('build'));
});
// gulp.task('default', ['build'], function(){
//     gulp.watch(exefile, ['build']);
// });
