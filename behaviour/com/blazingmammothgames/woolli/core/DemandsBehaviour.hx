package com.blazingmammothgames.woolli.core;

import buddy.*;
using buddy.Should;

/**
 * ...
 * @author Kenton Hamaluik
 */
class RandomBehaviour extends BuddySuite
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
		});
	}
}