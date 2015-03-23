package com.blazingmammothgames.woolli.library.systems;

import buddy.*;
import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.library.components.C_Acceleration;
import com.blazingmammothgames.woolli.library.components.C_Velocity;
import com.blazingmammothgames.woolli.library.systems.S_Acceleration;
using buddy.Should;

/**
 * ...
 * @author Kenton Hamaluik
 */
class S_AccelerationBehaviour extends BuddySuite
{
	public function new() 
	{
		describe("Using the Acceleration system", {
			it("should change the velocity of all entities based on the acceleration amount and the time step", {
				var e:Entity = new Entity();
				var entArray:Array<Entity> = new Array<Entity>();
				e.addComponent(new C_Acceleration(1, 2));
				e.addComponent(new C_Velocity(0, 0));
				entArray.push(e);

				var acceleration:S_Acceleration = new S_Acceleration();
				acceleration.processEntities(0.5, entArray);
				cast(e.getComponentByType(C_Velocity), C_Velocity).velocity.x.should.be(0.5);
				cast(e.getComponentByType(C_Velocity), C_Velocity).velocity.y.should.be(1);
			});
		});
	}
}