* Work in ipmc-dev3:~/stash/maloneyc/jats-tag-libraries
* My main XSLT: generate-jatsdoc.xslt.  This should be able to produce everything.
* Generate toc.html
    * C.f. ~/git/Klortho/JatsTagLibrary/publishing-1.0/toc.html


* Test it out, copying over an index.html from one of my existing jatsdoc tag sets.
    * Copied existing one to http://ipmc-dev3/cfm/web/jats-tag-libraries/jatsdoc-publishing-1.1d1/
    * Copied index.html, this now looks pretty good:
      http://ipmc-dev3/cfm/web/jats-tag-libraries/publishing/

* (c) Generate index.html - work on this
    - Opened https://jira.ncbi.nlm.nih.gov/browse/PMC-23096, because the tag libraries in Stash do
      not match what we have published.
    - Done for publishing
* (c) Now do how-to-use
* (c) pub-root - Root Element
* (c) pub-gen-intro - General Information

* Misc:
    * Are there any autolink!="yes"?
    * What about pe references?



To do:
* I'm going to need a perl wrapper script to copy resources, and run the generation stylesheet for
  each of the flavors.
    * Should copy  Blue-for-HTML/graphics to publishing/graphics
* Update jatsdoc in the repo, and redeploy it to dtd.nlm.nih.gov

