# jQAPI JATS adaptation project


# See also

See also my [JatsTagLibrary](https://github.com/Klortho/jatstaglibrary) project.
Eventually, the work specifically related to JATS Tag library should be moved there,
and this repository should just be about the javascript documentation framework.

Here is what I have so far:  [http://chrisbaloney.com/jqapi-jats/]().
  * The Table of Contents is working
  * Still need to adapt the documentation page contents.


# Change summary

## Changes to commands & procedures

* To generate the jQuery documentation static files, you used to enter
  `thor deploy:generate`.  Now, enter `thor deploy:generate --docset=jq`
* The command without the docset parameter (`thor deploy:generate`)
  now builds the default, "example" document set, from static HTML files in
  `app`.

## Changes to source code

* Moved some stuff from `app` into jq:
    * app/views/index.haml → jq/views/index.haml
    * app/assets/javascripts/entry.js.coffee → jq/assets/javascripts/entry.js.coffee
    * app/assets/javascripts/header.js.coffee → jq/assets/javascripts/header.js.coffee

* Changed the files in `app` to serve static HTML files.  These will be the
  default, "example" set of documentation.

* The `docs:generate` task generates the jQuery documentation set, which, before my
  changes, were in the `docs` directory.
  I moved it to `jq/content`. (I renamed `docs` -> `content`, because I felt that
  the name `docs` was already being used in too many places.)


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

