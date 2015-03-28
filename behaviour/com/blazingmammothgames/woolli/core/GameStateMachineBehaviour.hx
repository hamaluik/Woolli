package com.blazingmammothgames.woolli.core;

import com.blazingmammothgames.woolli.core.GameStateMachine;
import com.blazingmammothgames.woolli.core.Universe;
import com.blazingmammothgames.woolli.core.WoolliException;
import com.blazingmammothgames.woolli.mockups.*;

import buddy.*;
using buddy.Should;

/**
 * ...
 * @author Kenton Hamaluik
 */
class GameStateBehaviour extends BuddySuite
{
	public function new() 
	{
		describe("Using GameState", {
			var gsm:GameStateMachine;

			before({ gsm = new GameStateMachine(); });
			after({ gsm = null; });

			it("should allow you to add universes to the game using an instantiator", {
				gsm.addUniverse.bind("test", function():Universe { return new Universe(); }).should.not.throwType(WoolliException);
			});

			it("shouldn't allow you to add multiple universes with the same name", {
				gsm.addUniverse.bind("test", function():Universe { return new Universe(); }).should.not.throwType(WoolliException);
				gsm.addUniverse.bind("test", function():Universe { return new Universe(); }).should.throwType(WoolliException);
			});

			it("should allow you to switch universes", {
				gsm.addUniverse("test", function():Universe { return new Universe(); });
				gsm.switchUniverse.bind("test").should.not.throwType(WoolliException);
				gsm.currentUniverse.should.be("test");
			});

			it("should throw an exception if you attempt to switch to a universe which doesn't exist", {
				gsm.switchUniverse.bind("derp").should.throwType(WoolliException);
			});
		});
	}
}