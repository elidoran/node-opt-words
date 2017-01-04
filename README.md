# @opt/words
[![Build Status](https://travis-ci.org/elidoran/node-opt-words.svg?branch=master)](https://travis-ci.org/elidoran/node-opt-words)
[![Dependency Status](https://gemnasium.com/elidoran/node-opt-words.png)](https://gemnasium.com/elidoran/node-opt-words)
[![npm version](https://badge.fury.io/js/%40opt%2Fwords.svg)](http://badge.fury.io/js/%40opt%2Fwords)
[![Coverage Status](https://coveralls.io/repos/github/elidoran/node-opt-words/badge.svg?branch=master)](https://coveralls.io/github/elidoran/node-opt-words?branch=master)

Plugin for @opt/parse allowing words to be options for nopt.

See [@opt/parse](https://www.npmjs.com/package/@opt/parse)

See [@opt/nopt](https://www.npmjs.com/package/nopt)

See [@use/core](https://www.npmjs.com/package/@use/core)


## Install

```sh
npm install @opt/words --save
```


## Usage

```javascript
var parse = require('@opt/parse')

// make nopt the parser and apply our words plugin
parse.use('@opt/nopt', '@opt/words')

var options = {
  file: [String, Array] // accept multiple strings
}

var aliases = {
  // normal alias stuff for nopt still applies.
  // these are what's after the prefix '-' or '--'.
  f: '--file', // an example

  // here's what this plugin handles.
  $words: {
    // everything here is a whole word, not prefixed with anything.
    file: '--file'
  }
}

// an example args array
var argv = [ 'node', 'some.js', 'file', 'some/file.js' ]

// then use parse as you would use `nopt`,
// plus any changes made possible by the plugins added
options = parse(options, aliases, argv, 2)

// the above would produce:
options = {
  file: [ 'some/file.js' ],
  argv: {
    original: [ 'node', 'some.js', 'file', 'some/file.js' ]
    cooked  : [ 'node', 'some.js', '--file', 'some/file.js' ]
    remain  : []
  }
}

// nopt would have had no `file` values and remain would be:
// [ 'file', 'some/file.js' ]
```


## MIT License
