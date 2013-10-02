# jQAPI JATS adaptation project

# See also

See also my [JatsTagLibrary](https://github.com/Klortho/jatstaglibrary) project.
Eventually, the work specifically related to JATS Tag library should be moved there,
and this repository should just be about the javascript documentation framework.

Here is what I have so far:  [http://chrisbaloney.com/jqapi-jats/]().
  * The Table of Contents is working
  * Still need to adapt the documentation page contents.


# Switching from default documentation set (jqapi) to jats documentation set.

The goals in implementing this were:

* To use the exact same code base to serve either documentation set
* But not at the same time - you have to first run the appropriate steps to
  initialize the documentation set
* To keep the default behavior the same as the original jqapi code worked in
  every respect.

## Documentation set differences

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


# To do

* CSS issues
    * Need to verify that styles defined in, for example, jq/assets/stylesheets, will
      override any in app/assets/stylesheets
    * Note that the structure and classnames are all very jquery-doc-specific, but I
      think I shouldn't change them much.  Instead try to fit JATS docs to this
      structure.
* Bug:  in JATS, search doesn't work on element names (because of the angle-brackets?)
* Get the breadcrumbs to work - this will probably mean parsing the HTML into JSON for the main
  page.
* Create a documentation task that builds jats docs
* Get the "Original on jats..." link to work on each page.

