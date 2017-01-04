assert = require 'assert'
plugin = require '../../lib'

describe 'test plugin', ->

  it 'should wrap parse', ->
    result = argv: original:[],cooked:[],remain:[]
    parse = -> result
    opt = { parse }
    plugin null, opt # no options...
    assert opt.parse.parse, 'should have it stored under its parse'
    assert.equal opt.parse.parse, parse, 'should be the one we provided'
    assert.equal opt.parse(), result, 'should return our fake result'


describe 'test word options', ->

  ###
    These tests setup a similar structure as @opt/parse, apply our plugin,
    and then control what the inner parse would return to test our plugin's
    handling of that result.

    Also, see package `wopt`. I originally made that to wrap `nopt` and
    do the exact same thing; minus the plugin stuffs.
  ###

  # create a fake parser which calls inner parse, which is our fake parse
  parser = -> parser.parse.apply this, arguments
  # add the internal parser
  # return the value set into property 'output'
  parser.parse = -> parser.output

  # apply plugin
  plugin null, parser

  it 'should handle empty', ->
    # must specify the argv so it doesn't use the one initiating testing
    input = [ null, null, ['node', 'something.js'], null ]
    parser.output = answer =
      argv:
        original: []
        cooked  : []
        remain  : []

    output = parser.apply null, input
    assert.deepEqual output, answer

  it 'should handle usual options and aliases', ->

    input = [
      {
        version: Boolean
        help   : Boolean
      }
      {
        v: '--version'
        h: '--help'
        '?': '--help'
      }
      ['node', 'something.js', '--version', '--help']
      null
    ]
    parser.output = answer =
      version: true
      help   : true
      argv:
        original: ['--version', '--help']
        cooked  : ['--version', '--help']
        remain  : []

    output = parser.apply null, input
    assert.deepEqual output, answer

  it 'should handle usual options and aliases (2)', ->

    input = [
      {
        version: Boolean
        help   : Boolean
      }
      {
        v: '--version'
        h: '--help'
        '?': '--help'
      }
      ['node', 'something.js', '-v', '-h']
      null
    ]
    parser.output = answer =
      version: true
      help   : true
      argv:
        original: ['-v', '-h']
        cooked  : ['--version', '--help']
        remain  : []

    output = parser.apply null, input
    assert.deepEqual output, answer


  it 'should handle $words aliases', ->
    # should replace 'version' with '--version'
    # and replace '?' with '--help'
    input = [
      {
        version: Boolean
        help   : Boolean
      }
      {
        v: '--version'
        h: '--help'
        $words:
          version: '--version'
          '?': '--help'
      }
      ['node', 'something.js', 'version', '?']
      null
    ]
    parser.output =
      version: true
      help   : true
      argv:
        original: ['--version', '--help']
        cooked  : ['--version', '--help']
        remain  : []

    answer =
      version: true
      help   : true
      argv:
        original: ['version', '?']
        cooked  : ['--version', '--help']
        remain  : []

    output = parser.apply null, input
    assert.deepEqual output, answer

  it 'should handle $words aliases (with slice)', ->
    # should replace 'version' with '--version'
    # and replace '?' with '--help'
    input = [
      {
        version: Boolean
        help   : Boolean
      }
      {
        v: '--version'
        h: '--help'
        $words:
          version: '--version'
          '?': '--help'
      }
      ['node', 'something.js', 'version', '?']
      2
    ]
    parser.output =
      version: true
      help   : true
      argv:
        original: ['--version', '--help']
        cooked  : ['--version', '--help']
        remain  : []

    answer =
      version: true
      help   : true
      argv:
        original: ['version', '?']
        cooked  : ['--version', '--help']
        remain  : []

    output = parser.apply null, input
    assert.deepEqual output, answer

  it 'should handle $words aliases (with diff slice)', ->
    # should replace 'version' with '--version'
    # and replace '?' with '--help'
    input = [
      {
        version: Boolean
        help   : Boolean
      }
      {
        v: '--version'
        h: '--help'
        $words:
          version: '--version'
          '?': '--help'
      }
      ['something.js', 'version', '?']
      1
    ]
    parser.output =
      version: true
      help   : true
      argv:
        original: ['--version', '--help']
        cooked  : ['--version', '--help']
        remain  : []

    answer =
      version: true
      help   : true
      argv:
        original: ['version', '?']
        cooked  : ['--version', '--help']
        remain  : []

    output = parser.apply null, input
    assert.deepEqual output, answer
