# Implementation notes

## Contents

* [Miscellaneous notes](#miscellaneous-notes)
* [Project directory layout](#project-directory-layout)
* [Navigation panel](#navigation-panel)
* [Events](#events)
* [Tools](#tools)


## Project directory layout

```
├── air - Adobe air app.  I [cfm] don't know anything about this.
├── app
│   ├── assets
│   │   ├── images
│   │   │   ├── arrow.png
│   │   │   ├── ... various images and icons
│   │   ├── javascripts
│   │   │   ├── bundle.js.coffee - master file that "requires" all of the others,
│   │   │   │     including library files that aren't in this directory
│   │   │   ├── categories.js.coffee
│   │   │   ├── ... various coffeescript sources
│   │   └── stylesheets
│   │       ├── bundle.css.sass - master file that "requires" all of the others,
│   │       │     including the library file reset.css
│   │       ├── categories.css.sass
│   │       ├── ... various sass sources
│   ├── jqapi.rb - this is the main application ruby file, it maps all the URLs
│   └── views
│       └── index.haml - the top-level view
├── config.ru - config file for rackup; top-level configuration that defines the application.
│     This "requires" app/jqapi.rb
├── Gemfile - defines all the dependencies
├── LICENSE
├── README.md
├── tasks
│   ├── deploy.thor - defines a bunch of thor tasks:
│   │     1. generate - minifies css and js, copies all the files and framework, to create
│   │        a standalone version
│   │     2. pack - create a .zip file of the standalone version
│   │     3. air - for the Air app, not sure what that's about.
│   ├── development.thor - defines one thor task, dev:start, which starts the Sinatra server
│   ├── documentation.thor - defines two thor tasks:
│   │     1. docs:download - pull the official documentation form github (in XML)
│   │     2. docs:generate - convert XML into JSON format
│   └── requires.thor - "horrible hack" - this is a wrapper for the others.
└── vendor - third party libraries
    └── assets
        ├── javascripts - JS libraries
        │   ├── jquery.ba-bbq.js
        │   ├── jquery.ba-dotimeout.js
        │   ├── jquery.highlight.js
        │   ├── jquery.js
        │   ├── jquery.snippet.js
        │   └── sandbox.coffee
        └── stylesheets - CSS libraries
            └── reset.css
```

`bundle install` generates *Gemfile.lock*, which contains a snapshot of all of the
dependencies that were installed for this project.

`thor docs:download` downloads all of the jQuery documentation files into the
*tmp/api.jquery.com* directory tree.

`thor docs:generate` then converts that into JSON, and puts all of the results into
the *docs* directory:

```
└── docs
    ├── index.json - left-side navigation bar; nothing to do with index.haml.
    ├── categories.json - I'm [cfm] not sure this is used.
    ├── versions.json - I [cfm] don't know what this is used for.
    ├── entries
    │   ├── addBack.json
    │   ├── ... lots and lots of .json files
    │   └── wrap.json
    └── resources
        ├── 0042_04_01.png
        ├── ... lots of .pngs
        ├── animate-1.jpg
        ├── animate-2.jpg
        ├── events.js
        └── hat.gif
```

`thor deploy:generate` then shuffles things around quite a bit, putting results into the
*public* directory:

```
└── public
    ├── index.html - main content on the home page; built from index.haml
    ├── LICENSE
    ├── README.md
    ├── assets
    │   ├── bundle.css - this was bundled up and moved here, includes a bunch of library js's
    │   ├── bundle.js - this was bundled up and moved here, includes library reset.css ?
    │   ├── jquery.js - copied here from vendor/assets/javascripts?  diff doesn't match,
    │   │     but the changes are minimal
    │   ├── arrow.png
    │   └── ... various images and tools originally from assets
    ├── docs
    │   ├── index.json - left-side navigation bar; nothing to do with index.haml.
    │   ├── categories.json
    │   ├── versions.json
    │   └── entries
    │       ├── addBack.json
    │       ├── ... lots and lots of .json files
    │       └── wrap.json
    └── resources
        ├── 0042_04_01.png
        ├── ... lots of .pngs
        ├── 0042_06_44.png
        ├── animate-1.jpg
        ├── animate-2.jpg
        ├── events.js
        └── hat.gif
```


## Content

### Top-level "index" page



### Navigation panel

The left-side navigation panel is provided in the source markup for the home page
as

```html
<div id='sidebar-content'>
  <ul id='categories'>
    <li class='loader'>Loading...</li>
  </ul>
  <ul class='entries' id='results'>
    <li class='not-found'>Nothing found.</li>
  </ul>
</div>
```

In the original jqapi code, in *categories.js.coffee*, the content for this is loaded
via ajax from *docs/index.json*.  It built an HTML structure like this:

```html
<ul id='categories'>
  <li class='top-cat open'>
    <span class='top-cat-name'>Ajax</span>
    <ul class='sub-cats'>
      <li class='sub-cat open'>
        <span class='sub-cat-name'>Global Ajax Event Handlers</span>
        <ul class='entries'>
          <li class='entry' data-slug='ajaxStart'>
            <span class='title'>.ajaxStart()</span>
            <span class='desc'>Register a handler ...</span>
          </li>
          ...
        </ul>
      </li>
      ...
    </ul>
  </li>
</ul>
```


## Events

* categories:toggle
* entries:load
* entry:done
* entry:load
* index:done
* navigate:down
* navigate:enter
* navigate:up
* navigation:done
* search:clear
* search:done
* search:empty
* search:focus
* window:resize


### Managing hash state, loading entries

An onclick handler is set in *entries.js.coffee*, that responds to clicks within the
div#sidebar-content on any of the navigation items:

```coffee
@el.on 'click', '.entry,.top-cat,.sub-cat', ->
  self.loadEntry $(@)
```

Inside that event handler, `bbq.pushState` is called, which causes the browser
address to get the "#p=*slug*" added to it, and triggering a hashchange event:

```coffee
$.bbq.pushState { p: el.data('slug') }
```

In *init.js.coffee*, an event handler is set up for a hashchange event, that
in turn propogates an `entry:load` event:

```coffee
.on 'hashchange', ->                                  # on hash change, happens in entry load
  slug = $.bbq.getState('p')                          # slug of requested entry
  jqapi.events.trigger 'entry:load', [slug] if slug   # if the slug is set load the entry
```

In *entry.js.coffee*, a handler is set up for this event, that causes the content to
be loaded:

```coffee
jqapi.events.on 'entry:load', (e, slug) =>            # entry content must be loaded on this event
  ...
  @loadContent slug                                   # find content via the slug
  $.bbq.pushState { p: slug }                         # set the new hash state with old #p= format
```

Note that in the above sequence, `$.bbq.pushState()` gets called twice with the same
value, but it doesn't seem to do any harm.



## Tools

### Thor

Run `thor help` to get help on anything.  In particular, if you forget the various tasks
defined here, you can run one of these:

```
thor help docs
thor help dev
thor help deploy
```

