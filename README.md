# Jatsdoc Documentation Browser

This is a documentation browser library, developed in Ruby on Rails, that is
derived from [jqapi](https://github.com/jqapi/jqapi).

See it in action here:

* NISO JATS 1.0 Tag Library alternative browser:
  [Archiving and Interchange](http://jatspan.org/niso/archiving-1.0/),
  [Publishing](http://jatspan.org/niso/publishing-1.0/), and
  [Authoring](http://jatspan.org/niso/authoring-1.0/),
* Integrated with the documentation-generator of the
  [DtdAnalyzer](https://github.com/Klortho/DtdAnalyzer).

## Contents

* This page
    * [Development](#development)
    * [Deployment](#deployment)
    * [To do list](#to-do-list)
    * [See also](#see-also)
    * [Credits and license](#credits-and-license)
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


### Start the dev server

    bundle exec rackup

Point your browser to http://localhost:9292 and there you should see the sample
documentation, served with the jatsdoc library.


### Link to your own documentation

This repository includes a sample set of documentation files, that were generated
by the [DtdAnalyzer](http://dtd.nlm.nih.gov/ncbi/dtdanalyzer/), in the *docs*
directory of the project.

To see some other documentation set through the dev server, it's just necessary to
rename the repository *docs* directory, and then create a link with the name *docs*
to that other documentation set.


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
if the jatsdoc library is unzipped to the "/jatsdoc" directory at the root of your
server, you would change:

```html
<link href='/assets/favicon.ico' rel='shortcut icon' type='image/x-icon' />
<link href='/assets/jatsdoc.css' rel='stylesheet' type='text/css' />
<script src='/assets/jatsdoc.js' type='text/javascript'></script>
```

to:

```html
<link href='/jatsdoc/favicon.ico' rel='shortcut icon' type='image/x-icon' />
<link href='/jatsdoc/jatsdoc.css' rel='stylesheet' type='text/css' />
<script src='/jatsdoc/jatsdoc.js' type='text/javascript'></script>
```

### Release procedure

- Decide on a version number (e.g. 0.1).  (Right now, this isn't included in the code
  anywhere, but it should be.  See to-do item below.)
- Check the various README, Implementation, ..., files to make sure they are up-to-date
- git commit and push
- thor deploy:generate
- Try out this jatsdoc directory somewhere
- Tag it: `git tag -a v0.1 -m 'Tagging version 0.1'`
- Push:  `git push --tags`
- Zip it up:
    - `mv jatsdoc jatsdoc-0.1`
    - `zip -r jatsdoc-0.1.zip jatsdoc-0.1`
- Copy it to destination on dtd.nlm.nih.gov:
    - extract it to ncbi/jatsdoc/0.1
    - copy the zip file to ncbi/jatsdoc/downloads


## To do list

* Implement intra-page links, to targets within an entry (for example, the ones at the
  top of [this page](http://jatspan.org/niso/archiving-1.0/#p=general-introduction)).
  Because we're using the fragment identifier to specify the entry itself, we'll need
  something like `#p=entry;t=target`.

* Make a custom favicon.  Right now we're still using the jqapi one.

* Search needs to support matching headers ("categories" and "subcategories").  Right
  now, you only see the matching leaf nodes ("entries").

* When you open a hyperlink to another entry, the nav panel should scroll to bring that
  into view.

* Similarly, when you *first* go to the view and it has an entry already specified
  (e.g. following a link like [this](http://jatspan.org/niso/archiving-1.0/#p=attr-contrib-type)
  from outside) the navigation panel should open and scroll to the right spot.

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

* Implement a version number in the code somewhere.  This should show up in the deploy
  directory (i.e. "jatsdoc-1.0" instead of just "jatsdoc".)

* Instead of the instructions above for creating a softlink to a different documentation
  set under the dev server, figure out how to pass the location in as a parameter to
  rackup.  As it is now, if you're working on another documentation set, it will show
  up as a difference in your git repo.

* Make a home page for it?  Model it after http://dtd.nlm.nih.gov/ncbi/dtdanalyzer/.


## See also

* [GitHub Klortho/JatsTagLibrary](https://github.com/Klortho/JatsTagLibrary) -
  This is be the source of the *content* for the JATS Tag Library documentation
  (linked to above).

* [GitHub NCBITools/DtdAnalyzer](https://github.com/NCBITools/DtdAnalyzer)

## Credits and license

The [jQAPI software](https://github.com/jqapi/jqapi) is released under MIT and GPL
licenses, the full text of which can be found in the
[LICENSE](https://github.com/Klortho/jatsdoc/blob/master/LICENSE) file here.

Thanks to [Sebastian Senf](http://mustardamus.com/) and others (see [credits
here](http://jqapi.com/)) for producing such nice software.

Contributions from Chris Maloney are, to the extent permissible by law, in the
[public domain](http://creativecommons.org/publicdomain/zero/1.0/).



