class NavigationNode

	constructor: (@from, @to)->
		@actions = []
		
	registerAction: (action)-> @actions.push action

	registerActionAt: (position, action)-> @actions.splice _getIndexFrom.call(@, position), 0, action

	matches: (from, to)-> (not from? or @from is from) and (not to? or @to is to)

	_getIndexFrom = (position)->
		if typeof position is 'number'
			return 0 if position < 0
			return position if position <= @actions.length
			@actions.length
		else
			return 0 if position is "first"
			return @actions.length if position is "last"

return NavigationNode