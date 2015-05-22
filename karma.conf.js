// Karma configuration
// Generated on Thu May 21 2015 08:55:37 GMT-0400 (EDT)

module.exports = function(config) {
  config.set({
    basePath: '',
    frameworks: ['mocha-debug', 'mocha', 'chai', 'sinon', 'sinon-chai'],

    files: [
      'bower_components/jquery/dist/jquery.js',
      'bower_components/angular/angular.js',
      'bower_components/angular-mocks/angular-mocks.js',
      'fme-sortable.coffee',
      'spec/*.coffee'
    ],

    reporters: ['progress', 'coverage'],

    preprocessors: {
      'fme-sortable.coffee': ['coverage'],
      'spec/spec_helper.coffee': ['coffee'],
      'spec/fme-sortable-spec.coffee': ['coffee']
    },

    port: 9876,
    colors: true,
    autoWatch: true,
    singleRun: false,

    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_INFO,

    browsers: ['Chrome', 'PhantomJS'],

    // optionally, configure the reporter
    coverageReporter: {
      type : 'lcov',
      dir : 'coverage/'
    },

  });
};
