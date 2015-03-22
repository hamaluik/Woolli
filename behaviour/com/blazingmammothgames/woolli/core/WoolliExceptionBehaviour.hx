package com.blazingmammothgames.woolli.core;

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
			it("should allow an 'ignore' flag to be set");
			it("should construct different strings for ignorable and unignorable exceptions");
		});
	}
}