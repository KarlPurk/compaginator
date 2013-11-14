describe 'Integration > Compaginator', ->
  paginator = null

  beforeEach ->
    paginator = new Compaginator.Model()

  it 'should not display previous link when current page is 1', ->
    paginator.setCurrentPage 1
    expect(paginator.prevActive()).toBe false

  it 'should display previous link when current page is not 1', ->
    paginator.setCurrentPage 2
    expect(paginator.prevActive()).toBe true

  it 'should not display next link when current page is last page', ->
    paginator.setNumPages 2
    paginator.setCurrentPage 2
    expect(paginator.nextActive()).toBe false

  it 'should display next link when current page is not last page', ->
    paginator.setNumPages 2
    paginator.setCurrentPage 1
    expect(paginator.nextActive()).toBe true

  it 'should not require truncation when the num pages is equal to the num pages allowed', ->
    numPagesDisplayed = 7
    numPages = 7
    expect(paginator._requiresTruncation numPages, numPagesDisplayed).toBe false

  it 'should require truncation when there are more pages to display than is allowed', ->
    numPagesDisplayed = 7
    numPages = 8
    expect(paginator._requiresTruncation numPages, numPagesDisplayed).toBe true

  it 'should force numPagesAnchored to 2 if numPagesDisplayed is less than 11', ->
    paginator.setNumPagesDisplayed 11
    paginator.setNumPagesAnchored 3
    expect(paginator._numPagesAnchored).toBe 3
    paginator.setNumPagesDisplayed 7
    expect(paginator._numPagesAnchored).toBe 2


  it 'should contain elipses at position 2 under specified conditions', ->
    paginator.setNumPagesDisplayed 7
    paginator.setNumPagesAnchored 1
    paginator.setNumPages 20
    paginator.setCurrentPage 20
    pages = paginator.getDisplayPages()
    expect(pages[1].page).toBe '...'

  it 'should contain elipses at position -2 under specified conditions', ->
    paginator.setNumPagesDisplayed 7
    paginator.setNumPagesAnchored 1
    paginator.setNumPages 20
    paginator.setCurrentPage 1
    pages = paginator.getDisplayPages()
    expect(pages[-2..-2][0].page).toBe '...'

  it 'should contain elipses at position 2 and -2 under specified conditions', ->
    paginator.setNumPagesDisplayed 7
    paginator.setNumPagesAnchored 1
    paginator.setNumPages 20
    paginator.setCurrentPage 10
    pages = paginator.getDisplayPages()
    expect(pages[1].page).toBe '...'
    expect(pages[-2..-2][0].page).toBe '...'