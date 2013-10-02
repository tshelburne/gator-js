NavigationGraph = require 'gator/navigation_graph'
Navigator = require 'gator/navigator'
NavigationNode = require 'gator/navigation_node'

describe "NavigationGraph", ->
	graph = null
	failedAction = spyAction1 = spyAction2 = spyAction3 = spyAction4 = null	

	beforeEach ->
		graph = new NavigationGraph(new Navigator)
		
		graph.registerTransition 'initial', 'state1'
		graph.registerTransition 'state1', 'state2'

		failedAction = jasmine.createSpy('failedAction')
		graph.registerAction spyAction1 = jasmine.createSpy('spyAction1') 
		graph.registerAction spyAction2 = jasmine.createSpy('spyAction2'), 'state1'
		graph.registerAction spyAction3 = jasmine.createSpy('spyAction3'), null, 'state2'
		graph.registerAction spyAction4 = jasmine.createSpy('spyAction4'), 'initial', 'state1'

	describe "::create", ->

		it "will create a new NavigationGraph", ->
			expect(NavigationGraph.create().constructor).toEqual NavigationGraph

	describe "#registerTransition", ->

		it "will add a new navigation node to the list of nodes", ->
			expect(graph.nodes.length).toEqual 2
			expect(graph.nodes[0].constructor).toEqual NavigationNode

		it "will only add a transition once", ->
			graph.registerTransition 'initial', 'state1'
			expect(graph.nodes.length).toEqual 2

	describe "#hasTransition", ->

		it "will return true if the transition exists", ->
			expect(graph.hasTransition('initial', 'state1')).toBeTruthy()

		it "will return false if the transition doesn't exist", ->
			expect(graph.hasTransition('bad', 'state1')).toBeFalsy()

	describe "#getTransition", ->

		it "will return the navigation node when the transition exists", ->
			expect(graph.getTransition('initial', 'state1').constructor).toEqual NavigationNode

		it "will return null when no transition exists", ->
			expect(graph.getTransition('bad', 'state1')).toBeNull()

	describe "#registerAction", ->

		it "will register the actions to be run on the matching transitions", ->
			graph.transitionTo 'state1', 'context', failedAction
			expect(spyAction1).toHaveBeenCalled()
			expect(spyAction4).toHaveBeenCalled()

	describe "#registerActionAt", ->
		test = null

		firstAction = -> test = "first"

		lastAction = -> test = "last"

		it "will register the actions to be run on the matching transitions", ->
			graph.registerAction lastAction
			graph.registerActionAt "first", firstAction
			graph.transitionTo 'state1', 'context', failedAction
			expect(test).toEqual "last"

	describe "#canTransitionTo", ->

		it "will return true when the current state can transition to the given state", ->
			expect(graph.canTransitionTo 'state1').toBeTruthy()

		it "will return false when the current state can't transition to the given state", ->
			expect(graph.canTransitionTo 'state2').toBeFalsy()

	describe "#transitionTo", ->

		it "will run the actions associated with the given transition", ->
			graph.transitionTo 'state1', 'context', failedAction
			graph.transitionTo 'state2', 'context', failedAction
			expect(failedAction).not.toHaveBeenCalled()
			expect(spyAction1.calls.length).toEqual 2
			expect(spyAction2.calls.length).toEqual 1
			expect(spyAction3.calls.length).toEqual 1
			expect(spyAction4.calls.length).toEqual 1

		it "will update the currentFrom property to the new state", ->
			graph.transitionTo 'state1'
			expect(graph.currentFrom).toEqual 'state1'

		describe "when it can't transition to the given state", ->

			beforeEach ->
				graph.transitionTo 'state2', 'context', failedAction

			it "will call the failed action", ->
				expect(failedAction).toHaveBeenCalled()

			it "will not update the currentFrom property", ->
				expect(graph.currentFrom).toEqual 'initial'

		describe "when an action halts the transition", ->

			haltFxn = (nav)-> nav.halt()

			beforeEach ->
				graph.registerAction haltFxn
				graph.transitionTo 'state1', 'context', failedAction

			it "will call the failed action", ->
				expect(failedAction).toHaveBeenCalled()

			it "will not update the currentFrom property", ->
				expect(graph.currentFrom).toEqual 'initial'

		describe "when an action holds the transition", ->

			holdFxn = (nav)-> nav.hold()

			beforeEach ->
				graph.registerAction holdFxn
				graph.transitionTo 'state1', 'context', failedAction

			it "will not call the failed action", ->
				expect(failedAction).not.toHaveBeenCalled()

			it "will not update the currentFrom property", ->
				expect(graph.currentFrom).toEqual 'initial'

			describe "and continue is called", ->

				beforeEach ->
					graph.navigator.continue()

				it "will update the currentFrom property", ->
					expect(graph.currentFrom).toEqual 'state1'

		describe "when an action holds and continues the transition", ->

			holdAndContinueFxn = (nav)-> 
				nav.hold()
				nav.continue()

			beforeEach ->
				graph.registerAction holdAndContinueFxn
				graph.transitionTo 'state1', 'context', failedAction

			it "will not call the failed action", ->
				expect(failedAction).not.toHaveBeenCalled()

			it "will update the currentFrom property", ->
				expect(graph.currentFrom).toEqual 'state1'
