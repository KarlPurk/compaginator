window.Compaginator ?= {}
class window.Compaginator.Model

  constructor: ->
    @observers = []
    @setCurrentPage 1
    @setNumPagesDisplayed 11
    @setNumPagesAnchored 2

  # Returns a subset of pages for display
  getDisplayPages: ->

    # Create array of pages ranging from 1 to X
    pages = [1..@_numPages]

    # Reserve the first X pages
    firstPages = pages.slice 0, @_numPagesAnchored

    # Reserve the last X pages
    lastPages = pages.slice -@_numPagesAnchored

    # Reduce pages collection, removing previously reserved pages
    filteredPages = pages.slice @_numPagesAnchored, -@_numPagesAnchored

    # Truncate the pages if required
    if @_requiresTruncation @_numPages, @_numPagesDisplayed
      filteredPages = @_truncate  filteredPages,
        @_currentPage,
        @_numPageHoldersAvailable(@_numPagesDisplayed, @_numPagesAnchored)

    # concatanate pages
    filteredPages = firstPages.concat filteredPages.concat lastPages

    # Map each page to an object
    filteredPages.map (page) => @_createPage page, @_currentPage

  ###
    Truncate a collection of pages.
  ###
  _truncate: (pages, currentPage, available) ->


    {output, before, after} = @_splitPages pages, currentPage

    @_reducePages  output, available, before, after


  ###
    Split pages will take the collection of pages, extract the current page
    from the collection, and then create two new collections (excluding the current page)

    The method returns an object that contains three properties, output, before and after.
    The output collection will only ever contain a single element, the current page.
    The before collection will contain the pages before the current page.
    The after collection will contin the pages after the current page.

    For example:

      input:
        pages: [1,2,3,4,5,6,7,8,9,10]
        currentPage: 5

      output:
        output: 5
        before: 1,2,3,4
        after: 6,7,8,9,10
  ###
  _splitPages: (pages, currentPage) ->

    output = []
    before = []
    after = []

    # Determine index of current page
    index = pages.indexOf(currentPage)

    # If we have a current page
    if index isnt -1
      currentPage = pages[index]
      output.push currentPage
      before = pages.slice 0, index
      after = pages.slice (index + 1)
    else
      # If the current page number is less than the first page number
      if currentPage < pages[0]
        after = pages
      else
        before = pages

    return output: output, before: before, after: after

  ###
    Reduce two collections of pages, the collection of pages before the current page,
    and the collection of pages after the current page.  As we reduce the collections
    we build up the pages array, which already contains the current page.

    We push pages from the "after" collection into the pages collection, and we
    unshirt pages from the "before" collection into the pages collection.

    eg:

      input:
        pages: 10
        limit: 6
        before: 3,4,5,6,7,8,9
        after: 11,12,13,14,15,16,17,18

      output:
        ...,8,9,10,11,12,...

  ###
  _reducePages: (pages, limit, before, after) ->

    # While we can render pages
    while pages.length < limit

      # If we don't have any pages to render stop looping
      if !before.length and !after.length
        break

      # If we have pages to render before the current page
      if before.length
        pages.unshift(before.pop())

      # If we have pages to render after the current page
      if after.length
        pages.push(after.shift())

    # If we have more pages to render after the current page
    if after.length
      # Remove the last of the truncated pages and replace it with elipses
      pages.pop()
      pages.push('...')

    # If we have more pages to render before the current page
    if before.length
      # Remove the first of the truncates pages and replace it with elipses
      pages.shift()
      pages.unshift('...')

    pages

  ###
     Public Interface/API
  ###

  setNumPagesAnchored: (numPagesAnchored) ->
    @_numPagesAnchored = @_limitNumPagesAnchored(numPagesAnchored, @_numPagesDisplayed)

  setNumPagesDisplayed: (numPagesDisplayed) ->
    @_numPagesDisplayed = numPagesDisplayed
    @_numPagesAnchored = @_limitNumPagesAnchored(@_numPagesAnchored, @_numPagesDisplayed)

  setNumPages: (numPages) ->
    @_numPages = numPages

  setCurrentPage: (page) ->
    @_currentPage = +page
    @trigger 'page-changed', @_currentPage

  setNextPage: ->
    @setCurrentPage(@_currentPage + 1)

  setPrevPage: ->
    @setCurrentPage(@_currentPage - 1)

  getCurrentPage: () ->
    @_currentPage

  nextActive: ->
    if @_currentPage is @_numPages then false else true

  prevActive: ->
    if @_currentPage is 1 then false else true

  ###
    Helper methods
  ###

  ###
    Determines if the pagination requires truncating
  ###
  _requiresTruncation: (numPages, numPagesDisplayed) ->
    numPages > numPagesDisplayed

  ###
    Determine the number of page holders that are reserved
  ###
  _numPageHoldersAvailable: (numPagesDisplayed, numPagesAnchored) ->
    numPagesDisplayed - (numPagesAnchored * 2)

  _limitNumPagesAnchored: (numPagesAnchored, numPagesDisplayed) ->
    if numPagesDisplayed < 11
      if numPagesAnchored < 2 then numPagesAnchored else 2
    else
      numPagesAnchored

  ###
    Factory method for creating simple page objects that represent pages in the pagination
  ###
  _createPage: (page, currentPage) ->
    page: page
    active: if currentPage is page then true else false
    disabled: if page is '...' then true else false

  observe: (event, cb, context) ->
    @observers.push event: event, cb: cb, context: context

  trigger: (event, data) ->
    notifyObserver = (observer) =>
      if observer.event is event
        observer.cb.call observer.context ? @, data

    notifyObserver observer for observer in @observers