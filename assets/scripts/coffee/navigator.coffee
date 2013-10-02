Signal = require 'cronus/signal'

class Navigator

	constructor: ->
		@shouldHold = false
		@failedAction = null
		@transitionFinished = new Signal()

	perform: (@node=null, @context=null, @failedAction=null)-> 
		@pendingActions = (action for action in @node.actions)
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
			@transitionFinished.dispatch @node.to unless @pendingActions.length
		catch e
			if e.message is "Halt" then @failedAction?() else throw e

return Navigator