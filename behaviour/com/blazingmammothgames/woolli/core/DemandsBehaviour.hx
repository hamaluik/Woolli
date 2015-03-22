package com.blazingmammothgames.woolli.core;

import buddy.*;
using buddy.Should;

/**
 * ...
 * @author Kenton Hamaluik
 */
class DemandsBehaviour extends BuddySuite
{
	public function new() 
	{
		describe("Using Demands", {
			var demands:Demands;
			before({
				demands = new Demands();
			});
			after({
				demands = null;
			});

			it("should be able to chain-construct using requires", {
				demands.requires(Component).should.be(demands);
			});
			it("should be able to chain-construct using lacks", {
				demands.lacks(Component).should.be(demands);
			});
			it("should match an entity with at least one matching component");
			it("shouldn't match an entity that contains an undesired component");
			it("shouldn't be able to lack a component that it already requires");
			it("shouldn't be able to require a component that it already lacks");
			it("should throw an exception if you try to add the same component twice");
			it("should thrown an exception if you try to restrict the same component twice");
			it("should be able to match any entity when there are no requirements whatsoever");
			it("shouldn't match an entity if the entity is missing a required component");
			it("shouldn't match an entity if the entity has a restricted component");
			it("shouldn't match an entity if the entity's component has been disabled");
		});
	}
}