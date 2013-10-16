# Jatsdoc Documentation Browser

This is a documentation browser library, developed in Ruby on Rails, that is
derived from [jqapi](https://github.com/jqapi/jqapi).

## Contents

* This page
    * [Development](#development)
    * [Deployment](#deployment)
    * [To do list](#to-do-list)
    * [See also](#see-also)
    * [License](#license)
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

I found that there is one setting that's important to change, otherwise the
development server is intolerably slow.  Per [this SO
question](http://stackoverflow.com/questions/1156759/webrick-is-very-slow-to-respond-how-to-speed-it-up),
find your webrick configuration file (if you're using rvm, it's somewhere like
*~/.rvm/rubies/ruby-1.9.3-p448/lib/ruby/1.9.1/webrick/config.rb*)
and change `:DoNotReverseLookup` to `true`.

### Link to the documentation

You'll need to generate a documentation set in the correct format, and link to
it with a softlink named *docs*.

[In the to do list (below) is to include a small set of sample documentation files, so
you can play with the library right away.]


### Start the dev server

    bundle exec rackup

Point your browser to http://localhost:9292 and there you have the
documentation, served with the jatsdoc library.

## Deployment

### Generate static files (standalone version)

    thor deploy:generate

Generates *index.html*, *jatsdoc.js*, *jatsdoc.css*, etc., so that the documentation can be
viewed from a set of static files.  Everything is put into the *jatsdoc* directory,
which can then be served by a web server such as Apache.

### Changes to documentation files

When you deploy a set of documentation files to "production", as opposed to serving
them from the dev server, you'll need to change the URLs inside the index.html
page to point to the library resources at their deployed locations.  For example,
change

```html
<link href='/assets/favicon.ico' rel='shortcut icon' type='image/x-icon' />
<link href='/assets/jatsdoc.css' rel='stylesheet' type='text/css' />
<script src='/assets/jatsdoc.js' type='text/javascript'></script>
```

to:

```html
<link href='/jatsdoc-dev/favicon.ico' rel='shortcut icon' type='image/x-icon' />
<link href='/jatsdoc-dev/jatsdoc.css' rel='stylesheet' type='text/css' />
<script src='/jatsdoc-dev/jatsdoc.js' type='text/javascript'></script>
```


## To do list

* Search needs to support matching headers ("categories" and "subcategories").  Right
  now, you only see the matching leaf nodes ("entries").

* Figure out how to link to targets within an entry.  Because we're using the fragment
  identifier to specify the entry itself, we'll need something like
  "#p=entry;t=target".

* When you reload an page (F5), the navigation panel should open to show the page
  you are on.

* Fix back-button / reload when you go back to the home page.  I.e., when you start at
  http://chrismaloney.org/archiving-1.0/, click "Elements", and then click the back
  button.  The "entry" doesn't go back to the home page entry.

* Include a small set of test/sample documentation files in the docs directory of
  the github repository.  When this is done, we'll need to include instructions about
  how to switch to another docset by changing the values in *jqapi.rb*

* Polish the styles in the nav panel, regarding the nested categories and entries.
  See the [JatsAdaptation](JatsAdaptation#Accomodate different document structure)
  page for an explanation.
    - See http://api.rubyonrails.org/ for an example of how to fix
      the navigation pane styles
    - There's not enough visual distinction between a subcategory that is not
      expanded, and a blue row.  See "Common Tagging Practice" →
      "Tagging References", for example.
    - It's also not easy enough to see the hierarchy, where the "Tagging References"
      kids leave off and the siblings begin.
    - It would also be really nice to have a little miniature arrow on the subcategory
      boxes.
    - The arrow sprite needs more vertical separation.  If you shrink the window till
      "Document Hierarchy Diagrams" wraps, for example, you can see the other arrows
      underneath the real one.
    - Add some distinguishing styles for {top-cat open} and {sub-cat open}.  There
      are four different states that should be easy to distinguish; combinations of
      'active' and 'open'

* Implement a version number.  This should show up in the deploy directory (i.e.
  "jatsdoc-1.0" instead of just "jatsdoc".


## See also

* [GitHub Klortho/JatsTagLibrary](https://github.com/Klortho/JatsTagLibrary) -
  This will be the source of the *content* for the documentation.



## License

Released under MIT & GPL. Coded by Sebastian Senf. http://twitter.com/mustardamus

Code contributed by Chris Maloney is in the public domain.
