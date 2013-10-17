class jqapi.Entries
  constructor: ->
    self       = @                                        # keep a reference to this
    @el        = $ '#sidebar-content'                     # parent element of category and search result lists
    @currentEl = $ {}                                     # keep track of the current entry

    @el.on 'click', 'span.title,.top-cat-name,.sub-cat-name', ->    # on clicking a single entry
      $this = $(@)
      li = if ($this.prop("tagName") == "LI") then $this else $this.parent()
      self.loadEntry li

    jqapi.events.on 'entries:load', (e, entry) =>         # requested from outside to load entry
      @loadEntry entry                                    # do so

  loadEntry: (el) ->
    activeClass = 'active'

    unless el.is(@currentEl)                              # don't load the same entry twice
      @currentEl.removeClass activeClass                  # remove active class from recent el
      el.addClass activeClass                             # add it to the clicked entry
      el.removeClass 'hover'                              # remove any selection via keyboard

      @currentEl = el                                     # cache current entry

      $.bbq.pushState { p: el.data('slug') }              # update the hash to trigger entry loading
      jqapi.events.trigger 'search:focus'                 # set the lost focus on the search field