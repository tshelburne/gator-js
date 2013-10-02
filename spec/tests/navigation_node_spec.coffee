NavigationNode = require 'gator/navigation_node'

describe "NavigationNode", ->
	node = null

	beforeEach ->
		node = new NavigationNode('state1', 'state2')

	describe "#registerAction", ->
		spyAction = null

		beforeEach ->
			node.registerAction spyAction = jasmine.createSpy('spyAction')

		it "will add an action to the list of actions", ->
			expect(node.actions).toContain spyAction

	describe "#matches", ->

		it "will return true when both from and to match", ->
			expect(node.matches('state1', 'state2')).toBeTruthy()

		it "will return true when from matches and to is null", ->
			expect(node.matches('state1', null)).toBeTruthy()

		it "will return true when from is null and to matches", ->
			expect(node.matches(null, 'state2')).toBeTruthy()

		it "will return true when both from and to are null", ->
			expect(node.matches(null, null)).toBeTruthy()

		it "will return false when from doesn't match", ->
			expect(node.matches('bad-state', 'state2')).toBeFalsy()

		it "will return false when to doesn't match", ->
			expect(node.matches('state1', 'bad-state')).toBeFalsy()