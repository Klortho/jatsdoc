﻿# jQAPI JATS adaptation project

## Current status and strategy

### Strategy

- I am working on manually "rebasing" my changes from the dtdanalyzer branch (see below)
  onto the latest and greatest master branch from jqapi/jqapi, into the "jats" branch.
- Use the development server for dev/testing - keep this functional at all stages
- Don't change anything that doesn't need to be changed in the original code, esp. for
  aesthetic reasons.
- Absolutely no reason to have the same server be able to serve both sets of documentation
  at the same time.  Use an environment variable or command-line parameters to switch the
  docs from one to another.
- "docs:download" and "docs:generate" shouldn't be implemented in *this* project for
  the JATS documentation.  They should be implemented outside.
- I need to be faithful to the original documentation's structure, so that means there
  will need to be a couple of major improvements to the jqapi code.  In particular:
    - Headings are pages
    - How deeply are they nested?
    - Subheadings mixed in with pages (rather than putting them first)



### Work

- Add navigation panel (index.json)
    - Let's put it into an HTML file: docs-jats/toc.html
        - How do I communicate the configuration parameter docset into the categories.js?

    - app/assets/javascripts/categories.js.coffee,
      jq/assets/javascripts/categories.js.coffee
    - Need a way to pass in the "docset" parameter into this JS.
    - See also jats/content/jxml2json-2.xsl and/or jats/content/make-index-json.xsl -
      I think this is what I used to turn the Tag Library into index.json for the
      nav panel






- Other significant code changes in my old dtdanalyzer branch
    - app/assets/javascripts/entry.js.coffee,
      jq/assets/javascripts/entry.js.coffee
    - app/assets/javascripts/header.js.coffee,
      jq/assets/javascripts/header.js.coffee
    - tasks/deploy.thor
    - tasks/documentation.thor

- Major improvements:
    - Allow interspersing of sub-cats and entries
    - Allow pages to be loaded for categories and sub-cats

- To do:
    - Change "docs-jats" to "docs" everywhere, since we'll
      be using the same directory docs regardless of the docset
    - Figure out (ask Sebastian or Dr. Hazins) the proper way to pass in the
      docset parameter from thor to the jqapi.rb config file.


## dtdanalyzer branch

This is the original work I did on this project, before restarting it in October.

- ~/git/Klortho/jqapi-dtdanalyzer has the code where I last left off
- Here are the changes I made in the dtdanalyzer branch:
  https://github.com/Klortho/jqapi/compare/919ad7bade18e4...8e533982
* It is deployed to [http://chrisbaloney.com/jqapi-jats/](http://chrisbaloney.com/jqapi-jats/).
    * The Table of Contents is working
    * Still need to adapt the documentation page contents.


## See also

* [GitHub Klortho/JatsTagLibrary](https://github.com/Klortho/JatsTagLibrary) -
  This will be the source of the *content* for the documentation.



## Switching to the JATS documentation set

The goals in implementing this were:

* To use the exact same code base to serve either documentation set
* But not at the same time - you have to first run the appropriate steps to
  initialize the documentation set
* To keep the default behavior the same as the original jqapi code worked in
  every respect.

### Documentation set differences

In the JATS documentation set:

* The main home page will be served directly as *index.html*, rather than generated
  from *index.haml*.  So, I took it out of *app/views*, and put it with the rest of
  the static HTML files, in *docs* (for now, in *docs-jats*).

## Running the dev server

The original command for this, `thor dev:start`, still works the same, and brings up
the jqapi documentation on port 9292.

If you add the `-d jats` (or `--docset jats`) parameter, then it will bring up the JATS
documentation instead.  Implementation is a bit hacky right now:

* *tasks/development.thor* - added the `method_option`, and use that to invoke rackup
  with a config file other than the default *config.ru*.  When `docset` is "jats", the
  config file *jats.ru* is used.
* *jats.ru* - this is the same as *config.ru*, but sets a global variable `$docset`,
  that's used by the *jqapi.rb* config file.
* *jqapi.rb* - reads the global variable `$docset`, and changes some of the URL
  rules accordingly.


# Change summary

## Changes to commands & procedures

* To generate the jQuery documentation static files, you used to enter
  `thor deploy:generate`.  Now, enter `thor deploy:generate --docset=jq`


## Changes to source code

* Moved some stuff from `app` into jq:
    * app/assets/javascripts/entry.js.coffee → jq/assets/javascripts/entry.js.coffee
    * app/assets/javascripts/header.js.coffee → jq/assets/javascripts/header.js.coffee

* Changed the files in `app` to serve static HTML files.  These will be the
  default, "example" set of documentation.


# Old to do

These are old to-do items, from before I restarted the project with the *jats* branch.
I'm not sure if they still apply or not:

* CSS issues
    * Need to verify that styles defined in, for example, jq/assets/stylesheets, will
      override any in app/assets/stylesheets
    * Note that the structure and classnames are all very jquery-doc-specific, but I
      think I shouldn't change them much.  Instead try to fit JATS docs to this
      structure.
* Bug:  in JATS, search doesn't work on element names (because of the angle-brackets?)
* Get the breadcrumbs to work - this will probably mean parsing the HTML into JSON for the main
  page.
* Get the "Original on jats..." link to work on each page.
