package com.blazingmammothgames.woolli.library.systems;

import com.blazingmammothgames.woolli.core.Demands;
import com.blazingmammothgames.woolli.core.System;
import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.library.components.C_AABB;
import com.blazingmammothgames.woolli.library.components.C_Velocity;
import haxe.Timer;

/**
 * ...
 * @author Kenton Hamaluik
 */
class S_Velocity extends System
{

	public function new() 
	{
		super(new Demands().requires(C_AABB).requires(C_Velocity));
	}
	
	override public function processEntities(dt:Float, entities:Array<Entity>):Void
	{
		for (entity in entities)
		{
			var bounds:C_AABB = cast(entity.getComponentByType(C_AABB), C_AABB);
			var vel:C_Velocity = cast(entity.getComponentByType(C_Velocity), C_Velocity);
			
			if (vel.doMoveThisFrame)
			{
				bounds.center += vel.velocity * dt;
			}
			vel.doMoveThisFrame = true;
		}
	}
}