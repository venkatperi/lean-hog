dist = 'dist'
lib = 'lib'
srcs =
  coffee : [ lib + '/**/*.coffee', 'index.coffee' ]
  js : [ lib + '/**/*.js', 'index.js' ]

module.exports = ->
  @task 'coffee:dist',
    { src : srcs.coffee, dest : dist, ext : '.js', expand : true }

  @task 'clean:dist', dist, '*.{js,map}', 'lib/**/*.{map,js}'

  @task 'abc', -> @log.info 'test'

  @task 'default', [ 'clean:dist', 'coffee:dist' ]

