package com.blazingmammothgames.woolli.core;

import buddy.*;
using buddy.Should;

/**
 * ...
 * @author Kenton Hamaluik
 */
class EntityStateMachineBehaviour extends BuddySuite
{
	public function new() 
	{
		describe("Using an EntityStateMachine", {
			it("should allow you to ensure an entity has a component for a particular state");
			it("should provide a chainable interface to creating states");
			it("should provide a chainable interface to ensuring components");
			it("should be able to change the state of the entity");
			it("should change the composition of the entity's components when changing state");
			it("should throw an exception if you attempt to change to a state that doesn't exist");
			it("should allow you to define a custom instatiator function when ensuring components");
			it("should allow you to use a null instantiator to instantiate an empty component class");
			it("shouldn allow you to retain an instance of a component when switching states if desired");
		});
	}
}