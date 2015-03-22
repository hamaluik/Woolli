package com.blazingmammothgames.woolli.core;

import buddy.*;
using buddy.Should;

/**
 * ...
 * @author Kenton Hamaluik
 */
class UniverseBehaviour extends BuddySuite
{
	public function new() 
	{
		describe("Using Universe", {
			var universe:Universe;
			before({
				universe = new Universe();
			});
			after({
				universe = null;
			});

			it("should allow you to add a system");
			it("shouldn't pre-populate any systems");
			it("should allow you to remove a system");
			it("should throw an exception if you try to remove a non-existent system");
			it("should allow you to add an entity");
			it("shouldn't pre-populate any entities");
			it("should allow you to remove an entity");
			it("should throw an exception if you try to remove a non-existent entity");
			it("should process all enabled systems when it updates");
			it("shouldn't process disabled systems when it updates");
			it("should rebind all entities when a system is added");
			it("should rebind all entities when a system is removed");
			it("should bind an entity when that entity is added");
			it("should unbind an entity when that entity is removed");
			it("should rebind an entity when the entity is disabled or re-enabled");
			it("should rebind all entities when a system is disabled or re-enabled");
			it("should bind entities correctly based on their demands");
		});
	}
}