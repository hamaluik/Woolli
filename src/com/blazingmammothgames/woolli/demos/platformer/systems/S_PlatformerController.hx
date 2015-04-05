package com.blazingmammothgames.woolli.demos.platformer.systems;

import com.blazingmammothgames.woolli.core.Demands;
import com.blazingmammothgames.woolli.core.System;
import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.demos.platformer.components.C_PlatformerController;
import com.blazingmammothgames.woolli.library.components.C_Velocity;

/**
 * ...
 * @author Kenton Hamaluik
 */
class S_PlatformerController extends System
{
	public function new() 
	{
		super(new Demands().requires(C_Velocity).requires(C_PlatformerController));
	}
	
	override public function processEntities(dt:Float, entities:Array<Entity>):Void
	{
		for (entity in entities)
		{
			var velocity:C_Velocity = cast(entity.getComponentByType(C_Velocity), C_Velocity);
			var controller:C_PlatformerController = cast(entity.getComponentByType(C_PlatformerController), C_PlatformerController);
			
			velocity.velocity.x = controller.horizontal * controller.walkSpeed;
			
			// todo: only allow jumping when on ground
			if (controller.jump && Math.abs(velocity.velocity.y) < 0.01)
				velocity.velocity.y = -1 * controller.jumpSpeed;
		}
	}
}