$(document).ready ->

  paginator = new Compaginator.Model()
  paginator.setNumPages 20
  paginator.observe 'page-changed', ->
    topPaginatorView.render paginator, '.pagination-top'
    bottomPaginatorView.render paginator, '.pagination-bottom'

  topPaginatorView = new Compaginator.JqueryView paginator, '.pagination-top'
  bottomPaginatorView = new Compaginator.JqueryView paginator, '.pagination-bottom'