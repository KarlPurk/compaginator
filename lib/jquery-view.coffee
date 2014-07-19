window.Compaginator ?= {}

###
  Renders a pagination control using jQuery.
###
class window.Compaginator.JqueryView

  constructor: (paginator, cssSelector) ->
    @render paginator, cssSelector

  render: (paginator, cssSelector) ->

    template = new Template.Default()

    html = template.render paginator

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

Template = {}

###
  Renders a template using hardcoded strings.
  This template isn't very flexible but it works
  well with bootstrap out of the box.
###
class Template.Default

  render: (paginator) ->

    html = '<ul class="pagination">'
    html += @renderPrevious paginator

    $.each paginator.getDisplayPages(), (index, page) =>
      html += @renderPage page

    html += @renderNext paginator

    html += '</ul>'

  renderPage: (page) ->
    if page.active is true
      '<li class="active"><a href="#">' + page.page + '</a></li>'
    else
      if page.disabled is true
        '<li class="disabled"><a href="#">' + page.page + '</a></li>'
      else
        '<li class="clickable"><a href="#">' + page.page + '</a></li>'

  renderPrevious: (paginator) ->
    if paginator.prevActive()
      '<li class="previous"><a href="#">Previous</a></li>'
    else
      '<li class="disabled"><a href="#">Previous</a></li>'

  renderNext: (paginator) ->
    if paginator.nextActive()
      '<li class="next"><a href="#">Next</a></li>'
    else
      '<li class="disabled"><a href="#">Next</a></li>'