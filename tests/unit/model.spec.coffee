describe 'Unit > Compaginator', ->
  paginator = null

  beforeEach ->
    paginator = new Compaginator.Model()

  it '_limitNumPagesAnchored should force numPagesAnchored to 2 if numPagesDisplayed is less than 11', ->
    numPagesDisplayed = 11; numPagesAnchored = 3
    expect(paginator._limitNumPagesAnchored numPagesAnchored, numPagesDisplayed).toBe 3
    numPagesDisplayed = 7
    expect(paginator._limitNumPagesAnchored numPagesAnchored, numPagesDisplayed).toBe 2

  it '_reducePages should add elipses at the end if there are more pages to render after the current page', ->
    pages = [1]
    before = []
    after = [2..10]
    limit = 5
    output = paginator._reducePages pages, limit, before, after
    expect(output.length).toBe limit
    expect(output[0]).toBe 1
    expect(output[1]).toBe 2
    expect(output[2]).toBe 3
    expect(output[3]).toBe 4
    expect(output[4]).toBe '...'

  it '_reducePages should add elipses at the beginning if there are more pages to render before the current page', ->
    pages = [9]
    before = [2..8]
    after = []
    limit = 5
    output = paginator._reducePages pages, limit, before, after
    expect(output.length).toBe limit
    expect(output[0]).toBe '...'
    expect(output[1]).toBe 6
    expect(output[2]).toBe 7
    expect(output[3]).toBe 8
    expect(output[4]).toBe 9

  it '_reducePages should add elipses at both the beginning and end if there are more pages to render before and after the current page', ->
    pages = [5]
    before = [1..4]
    after = [6..10]
    limit = 5
    output = paginator._reducePages pages, limit, before, after
    expect(output.length).toBe limit
    expect(output[0]).toBe '...'
    expect(output[1]).toBe 4
    expect(output[2]).toBe 5
    expect(output[3]).toBe 6
    expect(output[4]).toBe '...'