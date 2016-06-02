grunt = require('grunt')
nopt = require('nopt')
gruntOptions = require('grunt-known-options')

cli = module.exports = ( options, done ) ->
  options =
    gruntfile : false

  Object.keys(options).forEach ( key ) ->
    if !(key of cli.options)
      return cli.options[ key ] = options[ key ]

    if cli.optlist[ key ].type == Array
      return [].push.apply(cli.options[ key ], options[ key ])

  grunt.tasks cli.tasks, cli.options, done

optlist = cli.optlist = gruntOptions
aliases = {}
known = {}
Object.keys(optlist).forEach ( key ) ->
  short = optlist[ key ].short
  if short
    aliases[ short ] = '--' + key
  known[ key ] = optlist[ key ].type

parsed = nopt(known, aliases, process.argv, 2)
cli.tasks = parsed.argv.remain
cli.options = parsed
delete parsed.argv

Object.keys(optlist).forEach ( key ) ->
  if optlist[ key ].type == Array and !(key of cli.options)
    return cli.options[ key ] = []
