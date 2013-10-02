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
			@allActionsRun = true
			while @pendingActions.length
				@allActionsRun = false
				action = @pendingActions.shift()
				action @, @context
				break if @shouldHold
				@allActionsRun = true unless @pendingActions.length
			@transitionFinished.dispatch @node.to if @allActionsRun
		catch e
			if e.message is "Halt" then @failedAction?() else throw e

return Navigator