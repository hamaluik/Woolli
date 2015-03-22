package com.blazingmammothgames.woolli.core;

import com.blazingmammothgames.woolli.core.WoolliException;

import buddy.*;
using buddy.Should;

/**
 * ...
 * @author Kenton Hamaluik
 */
class WoolliExceptionBehaviour extends BuddySuite
{
	public function new() 
	{
		describe("Creating a WoolliException", {
			it("should allow an 'ignore' flag to be set", {
				var exc:WoolliException = new WoolliException("test", true);
				exc.canIgnore.should.be(true);
			});
			it("should construct different strings for ignorable and unignorable exceptions", {
				(new WoolliException("test", true)).toString().should.not.be((new WoolliException("test", false)).toString());
			});
		});
	}
}