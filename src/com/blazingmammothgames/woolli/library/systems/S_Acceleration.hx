package com.blazingmammothgames.woolli.library.systems;

import com.blazingmammothgames.woolli.core.Demands;
import com.blazingmammothgames.woolli.core.System;
import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.library.components.C_Acceleration;
import com.blazingmammothgames.woolli.library.components.C_Velocity;

@author("Kenton Hamaluik")
@description("Changes the velocity of every bound entity by their acceleration each frame. Operates on all entities with #C_Acceleration and #C_Velocity components.")
class S_Acceleration extends System
{
	public function new() 
	{
		super(new Demands().requires(C_Acceleration).requires(C_Velocity));
	}
	
	@description("Called each frame, it updates shit")
	override public function processEntities(dt:Float, entities:Array<Entity>):Void
	{
		for (entity in entities)
		{
			var acc:C_Acceleration = cast(entity.getComponentByType(C_Acceleration), C_Acceleration);
			var vel:C_Velocity = cast(entity.getComponentByType(C_Velocity), C_Velocity);
			
			vel.velocity += acc.acceleration * dt;
		}
	}
}