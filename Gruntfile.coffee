path = require 'path'
src = [ 'lib/**/*.coffee', 'index.coffee' ]
dist = 'dist'

config = ( grunt ) ->
  tasks :
    coffee :
      options : { sourceMap : false, bare : true, force : true }
      dist : { expand : true, src : src, dest : dist, ext : '.js' }

    clean : { dist : [ dist, '*.{js,map}', 'lib/**/*.{map,js}' ] }

  register :
    default : [ 'clean:dist', 'coffee:dist' ]

doConfig = ( cfg ) -> ( grunt ) ->
  opts = cfg grunt
  pkg = opts.tasks.pkg = grunt.file.readJSON "package.json"
  grunt.initConfig opts.tasks
  opts.load ?= []
  dev = Object.keys pkg.devDependencies
  deps = (f for f in dev when f.indexOf('grunt-') is 0)
  opts.load = opts.load.concat deps
  grunt.loadNpmTasks t for t in opts.load

  for own name, tasks of opts.register
    grunt.registerTask name, tasks

module.exports = doConfig config
