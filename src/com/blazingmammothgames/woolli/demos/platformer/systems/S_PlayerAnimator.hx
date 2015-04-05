package com.blazingmammothgames.woolli.demos.platformer.systems;

import com.blazingmammothgames.woolli.core.Demands;
import com.blazingmammothgames.woolli.core.System;
import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.demos.platformer.components.C_PlatformerKeyboardControl;
import com.blazingmammothgames.woolli.library.components.C_Animated;
import com.blazingmammothgames.woolli.library.components.C_Sprite;
import com.blazingmammothgames.woolli.library.components.C_Velocity;

/**
 * ...
 * @author Kenton Hamaluik
 */
class S_PlayerAnimator extends System
{

	public function new() 
	{
		super(new Demands().requires(C_Velocity).requires(C_Animated).requires(C_Sprite).requires(C_PlatformerKeyboardControl));
	}
	
	override public function processEntities(dt:Float, entities:Array<Entity>):Void
	{
		for (entity in entities)
		{
			var vel:C_Velocity = cast(entity.getComponentByType(C_Velocity), C_Velocity);
			var anim:C_Animated = cast(entity.getComponentByType(C_Animated), C_Animated);
			var sprite:C_Sprite = cast(entity.getComponentByType(C_Sprite), C_Sprite);
			
			var nextAnim:String = '';
			if (vel.velocity.y > 0)
			{
				nextAnim = 'fall';
			}
			else if (vel.velocity.y < 0)
			{
				nextAnim = 'jump';
			}
			else if (Math.abs(vel.velocity.x) > 0)
			{
				nextAnim = 'run';
			}
			else
			{
				nextAnim = 'idle';
			}
			
			if (nextAnim != anim.currentAnimation)
			{
				anim.currentAnimation = nextAnim;
				anim.currentFrame = anim.animations.get(nextAnim).startFrame;
				anim.frameDirection = 1;
				anim.state = AnimationState.PLAYING;
			}
			
			if (vel.velocity.x < 0)
				sprite.flipped = true;
			else if (vel.velocity.x > 0)
				sprite.flipped = false;
		}
	}
}