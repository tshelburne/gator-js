class Navigator

	constructor: ->
		@shouldHold = false
		@failedAction = null

	perform: (node, @context, @failedAction)-> 
		@pendingActions = (action for action in node.actions)
		_run.call @, @pendingActions

	hold: -> @shouldHold = true

	continue: -> 
		@shouldHold = false
		_run.call @, @pendingActions

	halt: -> throw new Error "Halt"

	# PRIVATE

	_run = (actions)->
		try
			while @pendingActions.length
				action = @pendingActions.shift()
				action @, @context
				break if @shouldHold
		catch e
			if e.message is "Halt" then @failedAction?() else throw e
		finally
			@failedAction = @context = null

return Navigator