package com.blazingmammothgames.woolli.demos.platformer.systems;

import com.blazingmammothgames.woolli.core.Demands;
import com.blazingmammothgames.woolli.core.System;
import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.demos.platformer.components.C_PlatformerController;
import com.blazingmammothgames.woolli.library.components.C_GroundDetector;
import com.blazingmammothgames.woolli.library.components.C_Velocity;

/**
 * ...
 * @author Kenton Hamaluik
 */
class S_PlatformerController extends System
{
	public function new() 
	{
		super(new Demands().requires(C_Velocity).requires(C_PlatformerController).requires(C_GroundDetector));
	}
	
	override public function processEntities(dt:Float, entities:Array<Entity>):Void
	{
		for (entity in entities)
		{
			var velocity:C_Velocity = cast(entity.getComponentByType(C_Velocity), C_Velocity);
			var controller:C_PlatformerController = cast(entity.getComponentByType(C_PlatformerController), C_PlatformerController);
			var groundDetector:C_GroundDetector = cast(entity.getComponentByType(C_GroundDetector), C_GroundDetector);
			
			velocity.velocity.x = controller.horizontal * controller.walkSpeed;
			
			// todo: only allow jumping when on ground
			if (controller.jump && groundDetector.onGround)
				velocity.velocity.y = -1 * controller.jumpSpeed;
		}
	}
}