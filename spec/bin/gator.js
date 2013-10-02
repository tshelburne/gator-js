
(function() {
  var modules = window.modules || [];
  var navigation_graphCache = null;
  var navigation_graphFunc = function() {
    return (function() {
  var NavigationGraph, NavigationNode, Navigator;

  Navigator = require('gator/navigator');

  NavigationNode = require('gator/navigation_node');

  NavigationGraph = (function() {
    var _setFrom;

    function NavigationGraph(navigator) {
      this.navigator = navigator;
      this.nodes = [];
      this.currentFrom = 'initial';
      this.navigator.transitionFinished.add(_setFrom.call(this));
    }

    NavigationGraph.create = function() {
      return new this(new Navigator());
    };

    NavigationGraph.prototype.registerTransition = function(from, to) {
      if (!this.hasTransition(from, to)) {
        return this.nodes.push(new NavigationNode(from, to));
      }
    };

    NavigationGraph.prototype.hasTransition = function(from, to) {
      return this.getTransition(from, to) != null;
    };

    NavigationGraph.prototype.getTransition = function(from, to) {
      var node;

      return ((function() {
        var _i, _len, _ref, _results;

        _ref = this.nodes;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          node = _ref[_i];
          if (node.matches(from, to)) {
            _results.push(node);
          }
        }
        return _results;
      }).call(this))[0] || null;
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

    _setFrom = function() {
      var _this = this;

      return function(to) {
        return _this.currentFrom = to;
      };
    };

    return NavigationGraph;

  })();

  return NavigationGraph;

}).call(this);

  };
  modules.gator__navigation_graph = function() {
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
  modules.gator__navigation_node = function() {
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
  var Navigator, Signal;

  Signal = require('cronus/signal');

  Navigator = (function() {
    var _run;

    function Navigator() {
      var _this = this;

      this.inTransition = false;
      this.shouldHold = false;
      this.failedAction = null;
      this.transitionFinished = new Signal();
      this.transitionFinished.add(function() {
        return _this.inTransition = false;
      });
    }

    Navigator.prototype.perform = function(node, context, failedAction) {
      var action;

      if (node == null) {
        node = null;
      }
      if (context == null) {
        context = null;
      }
      if (failedAction == null) {
        failedAction = null;
      }
      if (this.inTransition) {
        throw new Error("The previous transition ('" + this.node.from + "' to '" + this.node.to + "') is not closed.");
      }
      this.node = node;
      this.context = context;
      this.failedAction = failedAction;
      this.pendingActions = (function() {
        var _i, _len, _ref, _results;

        _ref = this.node.actions;
        _results = [];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          action = _ref[_i];
          _results.push(action);
        }
        return _results;
      }).call(this);
      return _run.call(this, this.pendingActions);
    };

    Navigator.prototype.hold = function() {
      if (this.inTransition) {
        return this.shouldHold = true;
      }
    };

    Navigator.prototype["continue"] = function() {
      if (this.inTransition) {
        this.shouldHold = false;
        return _run.call(this, this.pendingActions);
      }
    };

    Navigator.prototype.halt = function() {
      if (this.inTransition) {
        if (this.shouldHold) {
          this.shouldHold = false;
          this.inTransition = false;
          return typeof this.failedAction === "function" ? this.failedAction() : void 0;
        } else {
          throw new Error("Halt");
        }
      }
    };

    _run = function(actions) {
      var action, e;

      this.inTransition = true;
      try {
        this.allActionsRun = true;
        while (this.pendingActions.length) {
          this.allActionsRun = false;
          action = this.pendingActions.shift();
          action(this, this.context);
          if (this.shouldHold) {
            break;
          }
          if (!this.pendingActions.length) {
            this.allActionsRun = true;
          }
        }
        if (this.allActionsRun) {
          return this.transitionFinished.dispatch(this.node.to);
        }
      } catch (_error) {
        e = _error;
        if (e.message === "Halt") {
          return typeof this.failedAction === "function" ? this.failedAction() : void 0;
        } else {
          throw e;
        }
      }
    };

    return Navigator;

  })();

  return Navigator;

}).call(this);

  };
  modules.gator__navigator = function() {
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

(function() {
  var modules = window.modules || [];
  var multi_signal_relayCache = null;
  var multi_signal_relayFunc = function() {
    return (function() {
  var MultiSignalRelay, Signal,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Signal = require("cronus/signal");

  MultiSignalRelay = (function(_super) {
    __extends(MultiSignalRelay, _super);

    function MultiSignalRelay(signals) {
      var signal, _i, _len;

      MultiSignalRelay.__super__.constructor.call(this);
      for (_i = 0, _len = signals.length; _i < _len; _i++) {
        signal = signals[_i];
        signal.add(this.dispatch);
      }
    }

    MultiSignalRelay.prototype.applyListeners = function(rest) {
      var listener, _i, _len, _ref, _results;

      _ref = this.listeners;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        listener = _ref[_i];
        _results.push(listener.apply(listener, rest));
      }
      return _results;
    };

    return MultiSignalRelay;

  })(Signal);

  return MultiSignalRelay;

}).call(this);

  };
  modules.cronus__multi_signal_relay = function() {
    if (multi_signal_relayCache === null) {
      multi_signal_relayCache = multi_signal_relayFunc();
    }
    return multi_signal_relayCache;
  };
  window.modules = modules;
})();

(function() {
  var modules = window.modules || [];
  var signalCache = null;
  var signalFunc = function() {
    return (function() {
  var Signal,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __slice = [].slice;

  Signal = (function() {
    function Signal() {
      this.dispatch = __bind(this.dispatch, this);      this.isApplyingListeners = false;
      this.listeners = [];
      this.onceListeners = [];
      this.removeCache = [];
    }

    Signal.prototype.add = function(listener) {
      return this.listeners.push(listener);
    };

    Signal.prototype.addOnce = function(listener) {
      this.onceListeners.push(listener);
      return this.add(listener);
    };

    Signal.prototype.remove = function(listener) {
      if (this.isApplyingListeners) {
        return this.removeCache.push(listener);
      } else {
        if (this.listeners.indexOf(listener) !== -1) {
          return this.listeners.splice(this.listeners.indexOf(listener), 1);
        }
      }
    };

    Signal.prototype.removeAll = function() {
      return this.listeners = [];
    };

    Signal.prototype.numListeners = function() {
      return this.listeners.length;
    };

    Signal.prototype.dispatch = function() {
      var rest;

      rest = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this.isApplyingListeners = true;
      this.applyListeners(rest);
      this.removeOnceListeners();
      this.isApplyingListeners = false;
      return this.clearRemoveCache();
    };

    Signal.prototype.applyListeners = function(rest) {
      var listener, _i, _len, _ref, _results;

      _ref = this.listeners;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        listener = _ref[_i];
        _results.push(listener.apply(listener, rest));
      }
      return _results;
    };

    Signal.prototype.removeOnceListeners = function() {
      var listener, _i, _len, _ref;

      _ref = this.onceListeners;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        listener = _ref[_i];
        this.remove(listener);
      }
      return this.onceListeners = [];
    };

    Signal.prototype.clearRemoveCache = function() {
      var listener, _i, _len, _ref;

      _ref = this.removeCache;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        listener = _ref[_i];
        this.remove(listener);
      }
      return this.removeCache = [];
    };

    return Signal;

  })();

  return Signal;

}).call(this);

  };
  modules.cronus__signal = function() {
    if (signalCache === null) {
      signalCache = signalFunc();
    }
    return signalCache;
  };
  window.modules = modules;
})();

(function() {
  var modules = window.modules || [];
  var signal_relayCache = null;
  var signal_relayFunc = function() {
    return (function() {
  var Signal, SignalRelay,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  Signal = require("cronus/signal");

  SignalRelay = (function(_super) {
    __extends(SignalRelay, _super);

    function SignalRelay(signal) {
      SignalRelay.__super__.constructor.call(this);
      signal.add(this.dispatch);
    }

    SignalRelay.prototype.applyListeners = function(rest) {
      var listener, _i, _len, _ref, _results;

      _ref = this.listeners;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        listener = _ref[_i];
        _results.push(listener.apply(listener, rest));
      }
      return _results;
    };

    return SignalRelay;

  })(Signal);

  return SignalRelay;

}).call(this);

  };
  modules.cronus__signal_relay = function() {
    if (signal_relayCache === null) {
      signal_relayCache = signal_relayFunc();
    }
    return signal_relayCache;
  };
  window.modules = modules;
})();
