NavigationNode = require 'gator/navigation_node'

describe "NavigationNode", ->
	node = null

	action = ->

	beforeEach ->
		node = new NavigationNode('state1', 'state2')

	describe "#registerAction", ->

		beforeEach ->
			node.registerAction action

		it "will add an action to the list of actions", ->
			expect(node.actions).toContain action

	describe "#registerActionAt", ->

		beforeEach ->
			node.registerAction ->
			node.registerAction ->
			node.registerAction ->

		it "will register negative positions at zero", ->
			node.registerActionAt -5, action
			expect(node.actions[0]).toEqual action

		it "will register positions within the action list's length at the requested position", ->
			node.registerActionAt 1, action
			expect(node.actions[1]).toEqual action

		it "will register positions greater than the action list's length as the last action", ->
			node.registerActionAt 5, action
			expect(node.actions[3]).toEqual action

		it "will register 'first' at the first position", ->
			node.registerActionAt 'first', action
			expect(node.actions[0]).toEqual action

		it "will register 'last' at the last position", ->
			node.registerActionAt 'last', action
			expect(node.actions[3]).toEqual action

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