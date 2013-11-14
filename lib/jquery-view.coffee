window.Compaginator ?= {}
class window.Compaginator.JqueryView

  constructor: (paginator, cssSelector) ->
    @render paginator, cssSelector

  render: (paginator, cssSelector) ->

    html = @constructor._renderPagination(paginator)

    el = $(cssSelector)
    el.html html

    @_initEvents paginator, cssSelector

  _initEvents: (paginator, cssSelector) ->

    $(cssSelector + ' ul li.clickable').on('click', ->
      paginator.setCurrentPage $(@).find('a').html()
      false
    )
    $(cssSelector + ' ul li.previous').on('click', ->
      paginator.setPrevPage $(@).find('a').html()
      false
    )
    $(cssSelector + ' ul li.next').on('click', ->
      paginator.setNextPage $(@).find('a').html()
      false
    )

  @_renderPagination: (paginator) ->

    html = '<ul class="pagination pagination-lg">'
    html += @_renderPrevious paginator

    $.each paginator.getDisplayPages(), (index, page) =>
      html += @_renderPage page

    html += @_renderNext paginator

    html += '</ul>'

  @_renderPage: (page) ->
      if page.active is true
        '<li class="active"><a href="#">' + page.page + '</a></li>'
      else
        if page.disabled is true
          '<li class="disabled"><a href="#">' + page.page + '</a></li>'
        else
          '<li class="clickable"><a href="#">' + page.page + '</a></li>'

  @_renderPrevious: (paginator) ->
    if paginator.prevActive()
      '<li class="previous"><a href="#">Previous</a></li>'
    else
      '<li class="disabled"><a href="#">Previous</a></li>'

  @_renderNext: (paginator) ->
    if paginator.nextActive()
      '<li class="next"><a href="#">Next</a></li>'
    else
      '<li class="disabled"><a href="#">Next</a></li>'