package com.blazingmammothgames.woolli.library.systems;

import buddy.*;
import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.util.Vector;
import com.blazingmammothgames.woolli.library.components.C_AABB;
import com.blazingmammothgames.woolli.library.components.C_Velocity;
import com.blazingmammothgames.woolli.library.systems.S_Velocity;
using buddy.Should;

/**
 * ...
 * @author Kenton Hamaluik
 */
class S_VelocityBehaviour extends BuddySuite
{
	public function new() 
	{
		describe("Using the Velocity system", {
			it("should move the centre of an AABB based on it's velocity and time delta", {
				var e:Entity = new Entity();
				var entArray:Array<Entity> = new Array<Entity>();
				e.addComponent(new C_Velocity(1, 2));
				e.addComponent(new C_AABB(Vector.zero, Vector.zero));
				entArray.push(e);

				var vel:S_Velocity = new S_Velocity();
				vel.processEntities(0.5, entArray);
				cast(e.getComponentByType(C_AABB), C_AABB).center.x.should.be(0.5);
				cast(e.getComponentByType(C_AABB), C_AABB).center.y.should.be(1);
			});
		});
	}
}