Navigator = require 'gator/navigator'
NavigationNode = require 'gator/navigation_node'

describe "Navigator", ->
	navigator = null

	beforeEach ->
		navigator = new Navigator()

	describe "#perform", ->
		node = null
		spyAction1 = spyAction2 = spyAction3 = null

		holdFxn = (nav)-> nav.hold()

		holdAndContinueFxn = (nav)->
			nav.hold()
			nav.continue()

		haltFxn = (nav)-> nav.halt()

		beforeEach ->
			node = new NavigationNode("state1", "state2")
			node.registerAction spyAction1 = jasmine.createSpy('spyAction1')
			node.registerAction spyAction2 = jasmine.createSpy('spyAction2')

		it "will run all the actions for the given node", ->
			navigator.perform node
			expect(action).toHaveBeenCalled() for action in [ spyAction1, spyAction2 ]

		it "will pass itself as a parameter and a context to each action", ->
			navigator.perform node, "context"
			expect(action).toHaveBeenCalledWith(navigator, "context") for action in [ spyAction1, spyAction2 ]

		describe "when using #hold", ->

			beforeEach ->
				node.registerAction holdFxn
				node.registerAction spyAction3 = jasmine.createSpy('spyAction3')
				navigator.perform node

			it "will pause execution after the current action", ->
				expect(spyAction3).not.toHaveBeenCalled()

			describe "and #continue", ->

				beforeEach ->
					navigator.continue()

				it "will remove the hold", ->
					expect(navigator.shouldHold).toBeFalsy()

				it "will resume running actions where it left off", ->
					expect(spyAction3).toHaveBeenCalled()

		describe "when using #hold and #continue in the action", ->

			beforeEach ->
				node.registerAction holdAndContinueFxn
				node.registerAction spyAction3 = jasmine.createSpy('spyAction3')
				navigator.perform node

			it "will run all actions", ->
				expect(spyAction3).toHaveBeenCalled()

		describe "when using #halt", ->

			beforeEach ->
				node.registerAction haltFxn
				node.registerAction spyAction3 = jasmine.createSpy('spyAction3')

			it "will immediately stop calling further actions", ->
				navigator.perform node
				expect(spyAction3).not.toHaveBeenCalled()

			it "will call the failed action callback", ->
				navigator.perform node, "context", failedAction = jasmine.createSpy('failedAction')
				expect(failedAction).toHaveBeenCalled()