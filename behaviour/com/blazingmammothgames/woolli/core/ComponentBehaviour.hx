package com.blazingmammothgames.woolli.core;

import com.blazingmammothgames.woolli.core.*;
import com.blazingmammothgames.woolli.mockups.*;

import buddy.*;
using buddy.Should;

/**
 * ...
 * @author Kenton Hamaluik
 */
class ComponentBehaviour extends BuddySuite
{
	public function new() 
	{
		describe("Using a Component", {
			it("should notify the universe when it becomes enabled or disabled", {
				var uni:MockUniverse = new MockUniverse();
				var sys:MockSystemA = new MockSystemA();
				uni.addSystem(sys);
				var ent:Entity = new Entity();
				var comp:MockComponentA = new MockComponentA();
				ent.addComponent(comp);
				uni.addEntity(ent);

				var sysEnt:Map<System, Array<Entity>> = uni.getSystemEntities();
				sysEnt.get(sys).indexOf(ent).should.be(0);

				ent.enabled = false;
				sysEnt = uni.getSystemEntities();
				sysEnt.get(sys).indexOf(ent).should.be(-1);
			});
		});
	}
}