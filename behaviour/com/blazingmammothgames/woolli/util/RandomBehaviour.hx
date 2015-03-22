package com.blazingmammothgames.woolli.util;

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
		describe("Using Random", {
			it("should be able to randomly flip a coin", {
				var result:Bool = Random.bool();
				if(result)
					result.should.be(true);
				else
					result.should.be(false);
			});
			it("should be able to get a random integer within a range", {
				for(i in 0...100)
				{
					var x = Random.int(0, 10);
					x.should.beLessThan(11);
					x.should.beGreaterThan(-1);
				}
			});
			it("should be able to get a random float within a range", {
				for(i in 0...100)
				{
					var x = Random.float(0, 10);
					x.should.beLessThan(11);
					x.should.beGreaterThan(-1);
				}
			});
		});
	}
}