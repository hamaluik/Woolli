package com.blazingmammothgames.woolli.util;

import buddy.*;
using buddy.Should;

/**
 * ...
 * @author Kenton Hamaluik
 */
class VectorBehaviour extends BuddySuite
{
	public function new() 
	{
		describe("Using Vector", {
			it("should create zero vectors that are actually 0", {
				var v:Vector = Vector.zero;
				v.x.should.be(0);
				v.y.should.be(0);
			});
			it("should calculate the length (2-norm) of a vector");
			it("should normalize a vector with a magnitude > 0");
			it("shouldn't crash when normalizing a vector with a magnitude of 0");
			it("should respect scalar math");
		});
	}
}