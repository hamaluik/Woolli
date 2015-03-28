package com.blazingmammothgames.woolli.library.systems;

import com.blazingmammothgames.woolli.core.Demands;
import com.blazingmammothgames.woolli.core.System;
import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.library.components.C_AABB;
import com.blazingmammothgames.woolli.library.components.C_Animated;
import com.blazingmammothgames.woolli.library.components.C_Sprite;
import haxe.Timer;

/**
 * ...
 * @author Kenton Hamaluik
 */
class S_Animator extends System
{

	public function new() 
	{
		super(new Demands().requires(C_Animated).requires(C_Sprite));
	}
	
	override public function processEntities(dt:Float, entities:Array<Entity>):Void
	{
		for (entity in entities)
		{
			var animated:C_Animated = cast(entity.getComponentByType(C_Animated), C_Animated);
			var sprite:C_Sprite = cast(entity.getComponentByType(C_Sprite), C_Sprite);
			
			if (animated.animations.exists(animated.currentAnimation))
			{
				var t:Float = Timer.stamp();
				if(t - animated.lastFrameTime >= animated.animations.get(animated.currentAnimation).framePeriod)
				{
					animated.currentFrame += animated.frameDirection;
					
					if (animated.currentFrame > animated.animations.get(animated.currentAnimation).endFrame)
					{
						switch(animated.animations.get(animated.currentAnimation).mode)
						{
							case AnimationMode.LOOP:
								animated.currentFrame = animated.animations.get(animated.currentAnimation).startFrame;
								animated.frameDirection = 1;
								break;
							case AnimationMode.ONCE:
								animated.currentFrame = animated.animations.get(animated.currentAnimation).endFrame;
								animated.currentAnimation = "";
								break;
							case AnimationMode.PINGPONG:
								animated.currentFrame = animated.animations.get(animated.currentAnimation).endFrame - 1;
								animated.frameDirection = -1;
								break;
						}
					}
					else if (animated.currentFrame < animated.animations.get(animated.currentAnimation).startFrame && animated.animations.get(animated.currentAnimation).mode == AnimationMode.PINGPONG)
					{
						animated.currentFrame = animated.animations.get(animated.currentAnimation).startFrame + 1;
						animated.frameDirection = 1;
					}
					
					animated.lastFrameTime = t;
				}
				sprite.tileNumber = animated.currentFrame;
			}
		}
	}
}