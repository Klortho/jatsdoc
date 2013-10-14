# jQAPI - Alternative jQuery Documentation Browser

This is a revamp of https://github.com/mustardamus/jqapi and still under development.

This particular fork/branch (Klortho/jqapi, jats branch) is an effort to adapt it to
the JATS Tag Library.

## Contents

* [Development](#development) - below
* [Implementation.md](Implementation.md) - notes about how it all works (from a Ruby newbie)
* [JatsAdaptation.md](JatsAdaptation.md) - info about the JATS adaptation effort, including list
  of major changes, to do list, etc.


## Development

The development environment consists of a Sinatra server and a Thor
tool belt.  Uses CoffeeScript and SASS.

### Install prerequisites

You need to have Ruby and RubyGems installed.

If you don't have already, install Bundler:

    gem install bundler

Then install all the other Gems:

    bundle install

### Link to the documentation

You'll need to generate a documentation set in the correct format, and link to
it with a softlink named *docs*.

### Start the dev server

    thor dev:start

Point your browser to localhost:9292 and there you have the latest jQuery documentation with jQAPI
wrapped around.

### Generate static files (standalone version)

    thor deploy:generate

Generates index.html, bundle.js, bundle.css, etc., so that the documentation can be
viewed from a set of static files.  Everything is put into the *public* directory,
which can then be served by a web server such as Apache.

## License

Released under MIT & GPL. Coded by Sebastian Senf. http://twitter.com/mustardamus

Code contributed by Chris Maloney is in the public domain.
