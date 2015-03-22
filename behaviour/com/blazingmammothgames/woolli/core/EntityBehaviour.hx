package com.blazingmammothgames.woolli.core;

import buddy.*;
using buddy.Should;

/**
 * ...
 * @author Kenton Hamaluik
 */
class EntityBehaviour extends BuddySuite
{
	public function new() 
	{
		describe("Using an Entity", {
			it("should increment the entity ID counter when it gets created");
			it("should be able to be set active or inactive");
			it("shouldn't have any components on it when it is first created");
			it("should be able to have components be added to it");
			it("should throw an exception if a component is added to it when it already has a component of that type");
			it("should be able to get a component instance based on a given type");
			it("should be able to remove components");
			it("should throw an exception when attempting to remove a component that doesn't exist");
			it("should be able to distinguish between inherited and parent component classes");
			it("should allow you to replace a component instance with a new one");
			it("should throw an exception if you try to replace a component that doesn't exist");
			it("should automatically create the statemachine the first time it is called");
		});
	}
}