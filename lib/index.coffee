'use strict'

# plugin function for @opt/parse via @use/core
module.exports = (options, opt) ->

  # remember the current parse implementation (should be nopt)
  parse = opt.parse

  # set our wrapping parser which handles words
  opt.parse = (options, aliases, args = process.argv, slice = 2) ->

    # let's do the slicing upfront because we may copy it for `original`
    args = args.slice slice

    # check for '$words' aliases in args and replace them
    if aliases?.$words?
      # remember the original args
      original = args.slice()
      words = aliases.$words
      # swap in all "word" aliases
      args[index] = words[arg] for arg,index in args when words[arg]?

    # finally, use parse implementation (nopt...) to get parsed options
    parsed = parse options, aliases, args, 0

    # set our "original" array from before we altered the words
    if original? then parsed.argv.original = original

    return parsed

  # put the original parse function on our function for testing availability
  opt.parse.parse = parse

  return
