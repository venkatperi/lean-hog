_ = require 'lodash'
grunt = require 'grunt'
cli = require './cli'

#check grunt version. Need >=1
ver = _.map grunt.version.split('.'), ( x ) -> Number x
unless ver[ 0 ] >= 1
  throw new Error "Need local grunt version >=1. Got #{grunt.version}"

log =
  info : ( msg ) -> grunt.log.writeln msg
  error : ( msg ) -> grunt.log.error msg
  debug : ( msg ) -> grunt.log.debug msg

class Hog
  constructor : ( opts = {} ) ->
    @log = log
    @config = {}
    @tasks = []

    @hogfile = grunt.file.findup('Hogfile.{js,coffee}', nocase : true)
    unless @hogfile
      return grunt.fatal('Unable to find Hogfile.',
        grunt.fail.code.MISSING_GRUNTFILE)

    require(@hogfile).call @
    @configGrunt()

  cli : -> cli()

  configGrunt : =>
    #console.log JSON.stringify @config, null, 2
    @pkg = grunt.file.readJSON('package.json')
    @config.pkg = @pkg
    grunt.initConfig @config
    @loadGruntNpmTasks()
    for t in @tasks
      grunt.registerTask.apply grunt, t

  loadGruntNpmTasks : =>
    dev = Object.keys @pkg.devDependencies
    deps = (f for f in dev when f.indexOf('grunt-') is 0)
    grunt.loadNpmTasks t for t in deps

  configure : ( opts ) ->
    @config = _.extend @config, opts

  task : ( name, arg... ) ->
    if Array.isArray name
      return @tasks.push name

    if name.indexOf(':') > 0
      cfg = {}
      [t, n] = name.split ':'
      cfg[ t ] = {}
      cfg[ t ][ n ] = if arg.length is 1 then arg[ 0 ] else arg
      return @configure cfg

    @tasks.push arguments

module.exports = Hog
