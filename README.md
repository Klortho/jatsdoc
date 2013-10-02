# jQAPI - Alternative jQuery Documentation Browser

This is a revamp of https://github.com/mustardamus/jqapi and still under development.

This particular fork/branch is an effort to adapt it to the JATS Tag Library.

## Contents:

* Development - below
* [Implementation.md](Implementation.md) - notes about how it all works (from a Ruby newbie)
* [JatsAdaptation.md](JatsAdaptation.md) - info about the JATS adaptation effort, including list
  of major changes, to do list, etc.


## Development

The development environment consists of a Sinatra server and a Thor
tool belt.

Served with Sprockets we can use CoffeeScript and SASS. Views will
be written in HAML.

### Install prerequisites

You need to have Ruby and RubyGems installed.

If you don't have already, install Bundler:

    gem install bundler

Then install all the other Gems:

    bundle install

### Generate the documentation

***Download it:***

    thor docs:download

The GitHub repo of the official docs site will be cloned/updated, and put into the
*tmp* directory.

***Generate it:***

    thor docs:generate

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
