# Implementation notes

## Contents

* [Project directory layout](#project-directory-layout)
* [Navigation panel](#navigation-panel)
* [Events](#events)
* [Tools](#tools)


## Project directory layout

```
├── README.md
├── config.ru - config file for rackup; top-level configuration that defines the application.
│     This "requires" app/jqapi.rb
├── app
│   ├── jqapi.rb - this is the main application ruby file, it maps all the URLs
│   └── assets
│       ├── images
│       │   ├── arrow.png
│       │   └── ... various images and icons
│       ├── javascripts
│       │   ├── jatsdoc.js.coffee - master file that "requires" all of the others,
│       │   │     including library files that aren't in this directory
│       │   ├── categories.js.coffee
│       │   └── ... other coffeescript sources
│       └── stylesheets
│           ├── jatsdoc.css.sass - master file that "requires" all of the others,
│           │     including the library file reset.css
│           ├── categories.css.sass
│           └── ... other sass sources
├── Gemfile - defines all the dependencies
├── LICENSE
├── tasks
│   ├── deploy.thor - defines a generate task, that minifies css and js, copies asset
│   │     files, to create the standalone version in *jatsdoc* (described below).
│   └── requires.thor - "horrible hack" - this is included by the others.
└── vendor - third party libraries
    └── assets
        ├── javascripts
        │   └── ... jquery and other JS libraries
        └── stylesheets - CSS libraries
            └── reset.css
```

`bundle install` generates *Gemfile.lock*, which contains a snapshot of all of the
dependencies that were installed for this project.

*docs* must be set up manually as a softlink from the root of the project directory,
to a documentation set that is generated externally, and must have this structure:

```
└── docs
    ├── index.html - main page
    ├── toc.html - the left-hand navigation panel
    ├── entries
    │   └── ... an html page for each of the entries
    └── resources
        └── ... content-specific images
```

`thor deploy:generate` puts the library files into the *jatsdoc* directory:

```
└── jatsdoc
    ├── README.md
    ├── LICENSE
    ├── jatsdoc.css - this was bundled up and moved here, includes a bunch of library js's
    ├── jatsdoc.js - this was bundled up and moved here, includes library reset.css ?
    └── ... images and tools originally from assets/images
```


## Content

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

The "p" hash parameter indicates which entry is being viewed.

But note that when you first load the page, regardless of what "p" is, the index.html
page loads, which has the "home page entry".  The home page entry will get replaced
when the user clicks a link to another entry.  In order that we can restore it when
needed, it is saved as `home_entry` in the (singleton) jqapi.Entry object.

When the page is first loaded, a hashchange event is manually triggered:

```coffee
winEl
  ...
  .trigger 'hashchange'                                 # initially kick it off
```

The hashchange handler is set by code that looks like this:

```coffee
winEl
  .on 'hashchange', ->                                  # on hash change, happens in entry load
    slug = $.bbq.getState('p')                          # slug of requested entry
    jqapi.events.trigger 'entry:load', [slug]           # load the entry, even if the slug is not defined
```

So, to recap:  an `entry:load` event is triggered both when the page first loads, and
whenever the hash changes.


In *entry.js.coffee*, a handler is set up for this event, that causes the content to
be loaded.  It keeps track of the "`first_time`" it is called, and if it is the first time,
and there is no slug, then that means the user just loaded the home page of the app, and
we don't want to replace the home page entry, so it returns.


```coffee
jqapi.events.on 'entry:load', (e, slug) =>            # entry content must be loaded on this event
  if @first_time
    @first_time = false
    return if !slug
  ...
```

If it's not the first time, and there is no slug, then we want to restore the home page entry:

```coffee
if !slug
  @restoreHomeEntry() if @home_entry
```

The entries in the navigation panel are handled by setting an onclick handler in
*entries.js.coffee*, that responds to clicks within the
div#sidebar-content on any of the navigation items.  It only causes an entry to be loaded
if there is an associated *@data-slug* attribute.

```coffee
@el.on 'click', '.entry,.top-cat,.sub-cat', ->
  $this = $(@)
  li = if ($this.prop("tagName") == "LI") then $this else $this.parent()
  if li.attr('data-slug') then self.loadEntry li
```

Inside that `loadEntry` event handler, `bbq.pushState` is called, which causes the browser
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

Note that in the above sequence, `$.bbq.pushState()` gets called twice with the same
value, but it doesn't seem to do any harm.


