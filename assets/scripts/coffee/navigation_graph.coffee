Navigator = require 'navigator'
NavigationNode = require 'navigation_node'

class NavigationGraph

	constructor: (@navigator)->
		@nodes = []
		@currentFrom = 'initial'
		@navigator.transitionFinished.add _setFrom.call @

	@create: -> 
		new @(new Navigator())

	registerTransition: (from, to)-> @nodes.push new NavigationNode(from, to) unless @hasTransition(from, to)

	hasTransition: (from, to)-> @getTransition(from, to)?

	getTransition: (from, to)-> (node for node in @nodes when node.matches(from, to))[0] or null

	registerAction: (action, from=null, to=null)-> node.registerAction action for node in @nodes when node.matches(from, to)

	canTransitionTo: (to)-> @hasTransition @currentFrom, to

	transitionTo: (to, context=null, failedAction=null)-> 
		if @canTransitionTo(to) 
			@navigator.perform @getTransition(@currentFrom, to), context, failedAction 
		else failedAction?()

	_setFrom = -> (to)=> @currentFrom = to

return NavigationGraph