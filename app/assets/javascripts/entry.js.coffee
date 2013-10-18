class jqapi.Entry

  constructor: ->
    @first_time   = true
    @home_entry   = $ '#entry-wrapper'
    @home_title   = document.title
    @footer       = $ '#footer'
    @el           = $ '#entry'                            # parent element
    @headerHeight = $('#header').outerHeight()            # cache the height of the header navigation

    # This will get called on initial page load, as well as every time the user clicks to
    # load a new entry.  If it's the initial page load, or if the user clicks the back button
    # to go back to the home page, then slug will be undefined.

    jqapi.events.on 'entry:load', (e, slug) =>            # entry content must be loaded on this event
      if @first_time
        @first_time = false
        return if !slug

      @el.scrollTop 0                                     # scroll the element back to top

      # If there's no slug, then restore the home entry
      if !slug
        @restoreHomeEntry() if @home_entry

      else
        $('#entry-wrapper', @el).hide()
        @footer.hide()
        @el.addClass 'loading'
        @loadContent slug                                   # find content via the slug
        $.bbq.pushState { p: slug }                         # set the new hash state with old #p= format

    jqapi.events.on 'window:resize', (e, winEl) =>        # on window resize event
      newHeight = winEl.height() - @headerHeight          # calculate new height
      @el.height newHeight                                # set new height

  loadContent: (slug) ->
    $.get "entries/#{slug}.html", (data) =>               # fetch from an html file
      data.slug = slug
      @parseHtmlEntry data                                # parse what was received
      jqapi.events.trigger 'entry:done', [data]           # let the app know that a new entry is loaded
      @el.removeClass 'loading'

  parseHtmlEntry: (entry) ->
    $('#entry-wrapper').replaceWith(entry)
    @footer.show()
    document.title = $(entry).find("h1").text()

  restoreHomeEntry: ->
    $('#entry-wrapper').replaceWith(@home_entry)
    @home_entry.show()
    document.title = @home_title
