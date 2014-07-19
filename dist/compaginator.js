/* Compaginator v0.0.1 */
(function() {
  var Template;

  if (window.Compaginator == null) {
    window.Compaginator = {};
  }

  /*
    Renders a pagination control using jQuery.
  */


  window.Compaginator.JqueryView = (function() {
    function JqueryView(paginator, cssSelector) {
      this.render(paginator, cssSelector);
    }

    JqueryView.prototype.render = function(paginator, cssSelector) {
      var el, html, template;
      template = new Template.Default();
      html = template.render(paginator);
      el = $(cssSelector);
      el.html(html);
      return this._initEvents(paginator, cssSelector);
    };

    JqueryView.prototype._initEvents = function(paginator, cssSelector) {
      $(cssSelector + ' ul li.clickable').on('click', function() {
        paginator.setCurrentPage($(this).find('a').html());
        return false;
      });
      $(cssSelector + ' ul li.previous').on('click', function() {
        paginator.setPrevPage($(this).find('a').html());
        return false;
      });
      return $(cssSelector + ' ul li.next').on('click', function() {
        paginator.setNextPage($(this).find('a').html());
        return false;
      });
    };

    return JqueryView;

  })();

  Template = {};

  /*
    Renders a template using hardcoded strings.
    This template isn't very flexible but it works
    well with bootstrap out of the box.
  */


  Template.Default = (function() {
    function Default() {}

    Default.prototype.render = function(paginator) {
      var html,
        _this = this;
      html = '<ul class="pagination">';
      html += this.renderPrevious(paginator);
      $.each(paginator.getDisplayPages(), function(index, page) {
        return html += _this.renderPage(page);
      });
      html += this.renderNext(paginator);
      return html += '</ul>';
    };

    Default.prototype.renderPage = function(page) {
      if (page.active === true) {
        return '<li class="active"><a href="#">' + page.page + '</a></li>';
      } else {
        if (page.disabled === true) {
          return '<li class="disabled"><a href="#">' + page.page + '</a></li>';
        } else {
          return '<li class="clickable"><a href="#">' + page.page + '</a></li>';
        }
      }
    };

    Default.prototype.renderPrevious = function(paginator) {
      if (paginator.prevActive()) {
        return '<li class="previous"><a href="#">Previous</a></li>';
      } else {
        return '<li class="disabled"><a href="#">Previous</a></li>';
      }
    };

    Default.prototype.renderNext = function(paginator) {
      if (paginator.nextActive()) {
        return '<li class="next"><a href="#">Next</a></li>';
      } else {
        return '<li class="disabled"><a href="#">Next</a></li>';
      }
    };

    return Default;

  })();

}).call(this);

(function() {
  if (window.Compaginator == null) {
    window.Compaginator = {};
  }

  window.Compaginator.Model = (function() {
    function Model() {
      this.observers = [];
      this.setCurrentPage(1);
      this.setNumPagesDisplayed(11);
      this.setNumPagesAnchored(2);
    }

    /*
      Truncate a collection of pages.
    */


    Model.prototype._truncate = function(pages, currentPage, available) {
      var after, before, output, _ref;
      _ref = this._splitPages(pages, currentPage), output = _ref.output, before = _ref.before, after = _ref.after;
      return this._reducePages(output, available, before, after);
    };

    /*
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
    */


    Model.prototype._splitPages = function(pages, currentPage) {
      var after, before, index, output;
      output = [];
      before = [];
      after = [];
      index = pages.indexOf(currentPage);
      if (index !== -1) {
        currentPage = pages[index];
        output.push(currentPage);
        before = pages.slice(0, index);
        after = pages.slice(index + 1);
      } else {
        if (currentPage < pages[0]) {
          after = pages;
        } else {
          before = pages;
        }
      }
      return {
        output: output,
        before: before,
        after: after
      };
    };

    /*
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
    */


    Model.prototype._reducePages = function(pages, limit, before, after) {
      while (pages.length < limit) {
        if (!before.length && !after.length) {
          break;
        }
        if (before.length) {
          pages.unshift(before.pop());
        }
        if (after.length) {
          pages.push(after.shift());
        }
      }
      if (after.length) {
        pages.pop();
        pages.push('...');
      }
      if (before.length) {
        pages.shift();
        pages.unshift('...');
      }
      return pages;
    };

    /*
       Public Interface/API
    */


    /*
      Returns a subset of pages for display
    */


    Model.prototype.getDisplayPages = function() {
      var filteredPages, firstPages, lastPages, pages, _i, _ref, _results,
        _this = this;
      pages = (function() {
        _results = [];
        for (var _i = 1, _ref = this._numPages; 1 <= _ref ? _i <= _ref : _i >= _ref; 1 <= _ref ? _i++ : _i--){ _results.push(_i); }
        return _results;
      }).apply(this);
      firstPages = pages.slice(0, this._numPagesAnchored);
      lastPages = pages.slice(-this._numPagesAnchored);
      filteredPages = pages.slice(this._numPagesAnchored, -this._numPagesAnchored);
      if (this._requiresTruncation(this._numPages, this._numPagesDisplayed)) {
        filteredPages = this._truncate(filteredPages, this._currentPage, this._numPageHoldersAvailable(this._numPagesDisplayed, this._numPagesAnchored));
      }
      filteredPages = firstPages.concat(filteredPages.concat(lastPages));
      return filteredPages.map(function(page) {
        return _this._createPage(page, _this._currentPage);
      });
    };

    Model.prototype.setNumPagesAnchored = function(numPagesAnchored) {
      return this._numPagesAnchored = this._limitNumPagesAnchored(numPagesAnchored, this._numPagesDisplayed);
    };

    Model.prototype.setNumPagesDisplayed = function(numPagesDisplayed) {
      this._numPagesDisplayed = numPagesDisplayed;
      return this._numPagesAnchored = this._limitNumPagesAnchored(this._numPagesAnchored, this._numPagesDisplayed);
    };

    Model.prototype.setNumPages = function(numPages) {
      return this._numPages = numPages;
    };

    Model.prototype.setCurrentPage = function(page) {
      this._currentPage = +page;
      return this._trigger('page-changed', this._currentPage);
    };

    Model.prototype.setNextPage = function() {
      return this.setCurrentPage(this._currentPage + 1);
    };

    Model.prototype.setPrevPage = function() {
      return this.setCurrentPage(this._currentPage - 1);
    };

    Model.prototype.getCurrentPage = function() {
      return this._currentPage;
    };

    Model.prototype.nextActive = function() {
      if (this._currentPage === this._numPages) {
        return false;
      } else {
        return true;
      }
    };

    Model.prototype.prevActive = function() {
      if (this._currentPage === 1) {
        return false;
      } else {
        return true;
      }
    };

    /*
      Observe the specified event and invoke the callback
      function when the event occurs.
    */


    Model.prototype.observe = function(event, cb, context) {
      return this.observers.push({
        event: event,
        cb: cb,
        context: context
      });
    };

    /*
      Helper methods
    */


    /*
      Determines if the pagination requires truncating
    */


    Model.prototype._requiresTruncation = function(numPages, numPagesDisplayed) {
      return numPages > numPagesDisplayed;
    };

    /*
      Determine the number of page holders that are reserved
    */


    Model.prototype._numPageHoldersAvailable = function(numPagesDisplayed, numPagesAnchored) {
      return numPagesDisplayed - (numPagesAnchored * 2);
    };

    Model.prototype._limitNumPagesAnchored = function(numPagesAnchored, numPagesDisplayed) {
      if (numPagesDisplayed < 11) {
        if (numPagesAnchored < 2) {
          return numPagesAnchored;
        } else {
          return 2;
        }
      } else {
        return numPagesAnchored;
      }
    };

    /*
      Factory method for creating simple page objects that represent pages in the pagination
    */


    Model.prototype._createPage = function(page, currentPage) {
      return {
        page: page,
        active: currentPage === page ? true : false,
        disabled: page === '...' ? true : false
      };
    };

    Model.prototype._trigger = function(event, data) {
      var notifyObserver, observer, _i, _len, _ref, _results,
        _this = this;
      notifyObserver = function(observer) {
        var _ref;
        if (observer.event === event) {
          return observer.cb.call((_ref = observer.context) != null ? _ref : _this, data);
        }
      };
      _ref = this.observers;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        observer = _ref[_i];
        _results.push(notifyObserver(observer));
      }
      return _results;
    };

    return Model;

  })();

}).call(this);
