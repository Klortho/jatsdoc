class jqapi.Categories
  constructor: ->
    @el  = $ '#categories'                                # parent ul element
    self = @

    jqapi.events.on 'navigation:done', =>                 # call when everything is loaded and generated
      @hideLoader()                                       # hide the loader

    jqapi.events.on 'search:empty', =>                    # on empty search input
      @el.show()                                          # show the general categories list

    jqapi.events.on 'search:done', =>                     # if a search was performed
      @el.hide()                                          # hide the categories list

    jqapi.events.on 'categories:toggle', (e, catEl) =>    # on request to toggle a category
      @toggleCategory catEl                               # toggle the category content


    # Switch between loading the navigation content as HTML vs. JSON
    # load the index html file with all categories and entries
    $.get 'toc.html', (html) =>
      data = @getNavigation html                        # and parse the data out from that html when loaded
      $(html).appendTo @el
      jqapi.events.trigger 'index:done', [data]         # let the app know that the index is loaded


    @el.on 'click', '.has-kids > .top-cat-name, .has-kids > .sub-cat-name', ->    # on clicking a category header
      self.toggleCategory $(@).parent()                   # toggle the category
      jqapi.events.trigger 'search:focus'                 # set the lost focus on the search field

  hideLoader: ->                                          # is called when loaded and generated
    @el.children('.loader').remove()                      # simply remove the loader for now


  getNavigation: (html) ->                                # parse the categories array out of the navigation html
    categories =  []

    $(html).find('li.top-cat').each (index, topcat) =>

      subcats = []
      for subcat in $(topcat).find('ul.sub-cats li.sub-cat')
        subcatEl = $(subcat)

        entries = []
        for entry in subcatEl.find('ul.entries li.entry')
          entryEl = $(entry)
          entries.push
            slug: entryEl.attr 'data-slug'
            title: entryEl.children('span.title').text()
            desc: entryEl.children('span.desc').text()

        subcats.push
          slug: subcatEl.attr 'data-slug'
          name: subcatEl.children('span.sub-cat-name').text()
          entries: entries

      entries = []
      for entry in $(topcat).find('ul.entries li.entry')
        entryEl = $(entry)
        entries.push
          slug: entryEl.attr 'data-slug'
          title: entryEl.children('span.title').text()
          desc: entryEl.children('span.desc').text()

      categories.push
        slug: $(topcat).attr 'data-slug'
        name: $(topcat).children('span.top-cat-name').text()
        subcats: subcats
        entries: entries

    jqapi.events.trigger 'navigation:done'                # everything done. let anybody know.
    categories

  toggleCategory: (catEl) ->
    catEl.toggleClass 'open'                              # toggle class open on li

