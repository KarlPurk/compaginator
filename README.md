Compaginator
=================

A framework agnostic JavaScript pagination component written in CoffeeScript.

Example usage  (CoffeeScript)
=================
    paginator = new Compaginator.Model()
    paginator.setNumPages 100
    paginator.setNumPagesDisplayed 10
    paginator.setNumPagesAnchored 2
    paginator.setCurrentPage 10
    pages = paginator.getDisplayPages()
    console.log pages.map (page) -> return page.page  # prints 1,2,...,8,9,10,11,12,...,99,100

Implementations
=================

Currently there are example implementations for the following frameworks/libraries:

- jQuery

Support for other frameworks & libraries will be coming soon.  Until then you can refer to the jQuery implementation for guidance.