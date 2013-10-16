class jqapi.Entry
  constructor: ->
    @el           = $ '#entry'                            # parent element
    @headerHeight = $('#header').outerHeight()            # cache the height of the header navigation

    jqapi.events.on 'entry:load', (e, slug) =>            # entry content must be loaded on this event
      @el.scrollTop 0                                     # scroll the element back to top
      $('#entry-wrapper', @el).hide()
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
    @el.html entry
    document.title = $(entry).find("h1").text()

