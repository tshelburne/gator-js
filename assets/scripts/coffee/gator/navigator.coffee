Signal = require 'cronus/signal'

class Navigator

	constructor: ->
		@inTransition = false
		@shouldHold = false
		@failedAction = null
		@transitionFinished = new Signal()
		@transitionFinished.add => @inTransition = false

	perform: (@node=null, @context=null, @failedAction=null)-> 
		@pendingActions = (action for action in @node.actions)
		_run.call @, @pendingActions

	hold: -> @shouldHold = true if @inTransition 

	continue: -> 
		if @inTransition
			@shouldHold = false
			_run.call @, @pendingActions

	halt: -> 
		if @inTransition
			if @shouldHold
				@shouldHold = false
				@inTransition = false
				@failedAction?()
			else	
				throw new Error "Halt"

	# PRIVATE

	_run = (actions)->
		@inTransition = true
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