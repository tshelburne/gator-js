class NavigationNode

	constructor: (@from, @to)->
		@actions = []
		
	registerAction: (action)-> @actions.push action

	matches: (from, to)-> (not from? or @from is from) and (not to? or @to is to)

return NavigationNode