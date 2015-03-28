package com.blazingmammothgames.woolli.library.systems;

import com.blazingmammothgames.woolli.core.Demands;
import com.blazingmammothgames.woolli.core.System;
import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.library.components.C_AABB;
import com.blazingmammothgames.woolli.library.components.C_Camera;
import com.blazingmammothgames.woolli.util.Vector;
import haxe.Timer;
import openfl.display.Sprite;
import openfl.Lib;

/**
 * ...
 * @author Kenton Hamaluik
 */
class S_Camera extends System
{
	var root:Sprite = null;

	public function new(sceneRoot:Sprite) 
	{
		super(new Demands().requires(C_Camera));
		this.root = sceneRoot;
		
		// set the scale
		root.scaleX = 1;
		root.scaleY = 1;
		
		// translate it into place
		root.x = 0;
		root.y = 0;
	}
	
	override public function processEntities(dt:Float, entities:Array<Entity>):Void
	{
		for (entity in entities)
		{
			var camera:C_Camera = cast(entity.getComponentByType(C_Camera), C_Camera);
			if (camera.enabled)
			{
				root.stage.color = camera.clearColour;
				root.scaleX = camera.zoom;
				root.scaleY = camera.zoom;
				
				if (camera.followTarget != null)
				{
					camera.centre = Vector.roundToOne(camera.followTarget.center) * -1 * camera.zoom;
				}
				
				root.x = camera.centre.x + (root.stage.stageWidth / 2);
				root.y = camera.centre.y + (root.stage.stageHeight / 2);
			
				// only do one camera at a time
				return;
			}
		}
	}
}