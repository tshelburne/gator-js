
(function() {
  var modules = window.modules || [];
  var navigation_graphCache = null;
  var navigation_graphFunc = function() {
    return (function() {
  var NavigationGraph, NavigationNode, Navigator;

  Navigator = require('navigator');

  NavigationNode = require('navigation_node');

  NavigationGraph = (function() {
    function NavigationGraph(navigator) {
      this.navigator = navigator;
      this.nodes = [];
      this.currentFrom = null;
    }

    NavigationGraph.create = function() {
      return this(new Navigator());
    };

    NavigationGraph.prototype.registerTransition = function(from, to) {
      if (!this.hasTransition(from, to)) {
        return this.nodes.push(new NavigationNode(from, to));
      }
    };

    NavigationGraph.prototype.hasTransition = function(from, to) {
      return getTransition(from, to) != null;
    };

    NavigationGraph.prototype.getTransition = function(from, to) {
      var node, _i, _len, _ref, _results;

      _ref = this.nodes;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        node = _ref[_i];
        if (node.matches(from, to)) {
          _results.push(node);
        }
      }
      return _results;
    };

    NavigationGraph.prototype.registerAction = function(action, from, to) {
      var node, _i, _len, _ref, _results;

      if (from == null) {
        from = null;
      }
      if (to == null) {
        to = null;
      }
      _ref = this.nodes;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        node = _ref[_i];
        if (node.matches(from, to)) {
          _results.push(node.registerAction(action));
        }
      }
      return _results;
    };

    NavigationGraph.prototype.canTransitionTo = function(to) {
      return this.hasTransition(this.currentFrom, to);
    };

    NavigationGraph.prototype.transitionTo = function(to, context, failedAction) {
      if (context == null) {
        context = null;
      }
      if (failedAction == null) {
        failedAction = null;
      }
      if (this.canTransitionTo(to)) {
        return this.navigator.perform(this.getTransition(this.currentFrom, to), context, failedAction);
      } else {
        return typeof failedAction === "function" ? failedAction() : void 0;
      }
    };

    return NavigationGraph;

  })();

  return NavigationGraph;

}).call(this);

  };
  modules.__navigation_graph = function() {
    if (navigation_graphCache === null) {
      navigation_graphCache = navigation_graphFunc();
    }
    return navigation_graphCache;
  };
  window.modules = modules;
})();

(function() {
  var modules = window.modules || [];
  var navigation_nodeCache = null;
  var navigation_nodeFunc = function() {
    return (function() {
  var NavigationNode;

  NavigationNode = (function() {
    function NavigationNode(from, to) {
      this.from = from;
      this.to = to;
      this.actions = [];
    }

    NavigationNode.prototype.registerAction = function(action) {
      return this.actions.push(action);
    };

    NavigationNode.prototype.matches = function(from, to) {
      return ((from == null) || this.from === from) && ((to == null) || this.to === to);
    };

    return NavigationNode;

  })();

  return NavigationNode;

}).call(this);

  };
  modules.__navigation_node = function() {
    if (navigation_nodeCache === null) {
      navigation_nodeCache = navigation_nodeFunc();
    }
    return navigation_nodeCache;
  };
  window.modules = modules;
})();

(function() {
  var modules = window.modules || [];
  var navigatorCache = null;
  var navigatorFunc = function() {
    return (function() {
  var Navigator;

  Navigator = (function() {
    var _run;

    function Navigator() {
      this.shouldHold = false;
      this.failedAction = null;
    }

    Navigator.prototype.perform = function(node, context, failedAction) {
      var action;

      this.context = context;
      this.failedAction = failedAction;
      this.pendingActions = (function() {
        var _i, _len, _ref, _results;

        _ref = node.actions;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          action = _ref[_i];
          _results.push(action);
        }
        return _results;
      })();
      return _run.call(this, this.pendingActions);
    };

    Navigator.prototype.hold = function() {
      return this.shouldHold = true;
    };

    Navigator.prototype["continue"] = function() {
      this.shouldHold = false;
      return _run.call(this, this.pendingActions);
    };

    Navigator.prototype.halt = function() {
      throw new Error("Halt");
    };

    _run = function(actions) {
      var action, e, _results;

      try {
        _results = [];
        while (this.pendingActions.length) {
          action = this.pendingActions.shift();
          action(this, this.context);
          if (this.shouldHold) {
            break;
          } else {
            _results.push(void 0);
          }
        }
        return _results;
      } catch (_error) {
        e = _error;
        if (e.message === "Halt") {
          return typeof this.failedAction === "function" ? this.failedAction() : void 0;
        } else {
          throw e;
        }
      } finally {
        this.failedAction = this.context = null;
      }
    };

    return Navigator;

  })();

  return Navigator;

}).call(this);

  };
  modules.__navigator = function() {
    if (navigatorCache === null) {
      navigatorCache = navigatorFunc();
    }
    return navigatorCache;
  };
  window.modules = modules;
})();

(function() {
  var modules = window.modules || [];
  window.require = function(path) {
    var transformedPath = path.replace(/\//g, '__');
    if (transformedPath.indexOf('__') === -1) {
      transformedPath = '__' + transformedPath;
    }
    var factory = modules[transformedPath];
    if (factory === null) {
      return null;
    } else {
      return modules[transformedPath]();
    }
  };
})();
