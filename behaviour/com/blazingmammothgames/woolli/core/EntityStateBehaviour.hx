package com.blazingmammothgames.woolli.core;

import buddy.*;
using buddy.Should;

/**
 * ...
 * @author Kenton Hamaluik
 */
class EntityStateBehaviour extends BuddySuite
{
	public function new() 
	{
		describe("Using EntityState", {
			it("should allow you to add components based on their type");
			it("should throw an exception if you attemp to add more than one component of the same type");
			it("should allow you to check if the state has a component by type");
			it("should be able to instantiate a component");
			it("should be able to list the component types assosciated with a given state");
		});
	}
}