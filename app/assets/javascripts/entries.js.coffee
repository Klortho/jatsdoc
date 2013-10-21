class jqapi.Entries
  constructor: ->
    self       = @                                        # keep a reference to this
    @el        = $ '#sidebar-content'                     # parent element of category and search result lists
    @currentEl = $ {}                                     # keep track of the current entry

    @el.on 'click', 'span.title,.top-cat-name,.sub-cat-name', ->    # on clicking a single entry
      $this = $(@)
      li = if ($this.prop("tagName") == "LI") then $this else $this.parent()
      if li.attr('data-slug') then self.loadEntry li

    jqapi.events.on 'entries:load', (e, entry) =>         # requested from outside to load entry
      @loadEntry entry                                    # do so


  # click event handler for entries in the navigation panel
  loadEntry: (el) ->
    activeClass = 'active'

    # FIXME:  the code to handle the `active` class should be moved to where the entry gets
    # loaded.  That way, it will correctly track when an entry gets loaded through other
    # means (like clicking on a link).
    unless el.is(@currentEl)                              # don't load the same entry twice
      #@currentEl.removeClass activeClass                  # remove active class from recent el
      #el.addClass activeClass                             # add it to the clicked entry
      el.removeClass 'hover'                              # remove any selection via keyboard
      @currentEl = el                                     # cache current entry

      $.bbq.pushState { p: el.data('slug') }              # update the hash to trigger entry loading
      jqapi.events.trigger 'search:focus'                 # set the lost focus on the search field
