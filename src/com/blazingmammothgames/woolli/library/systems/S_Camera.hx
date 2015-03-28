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
	//var root:Sprite = null;

	public function new() 
	{
		super(new Demands().requires(C_Camera));
	}
	
	public static function screenToWorld(camera:C_Camera, point:Vector):Vector
	{
		return (point - new Vector(Lib.current.stage.stageWidth / 2, Lib.current.stage.stageHeight / 2) - camera.centre) / camera.zoom;
	}
	
	public static function worldToScreen(camera:C_Camera, point:Vector):Vector
	{
		return (point * camera.zoom) + new Vector(Lib.current.stage.stageWidth / 2, Lib.current.stage.stageHeight / 2) + camera.centre;
	}
	
	override public function processEntities(dt:Float, entities:Array<Entity>):Void
	{
		for (entity in entities)
		{
			var camera:C_Camera = cast(entity.getComponentByType(C_Camera), C_Camera);
			if (camera.enabled)
			{
				camera.buffer.stage.color = camera.clearColour;
				camera.buffer.scaleX = camera.zoom;
				camera.buffer.scaleY = camera.zoom;
				
				var centre:Vector = Vector.roundToOne(camera.centre) * -1 * camera.zoom;
				if (camera.followTarget != null)
				{
					camera.centre = Vector.roundToOne(camera.followTarget.center) * -1 * camera.zoom;
				}
				
				camera.buffer.x = centre.x + (camera.buffer.stage.stageWidth / 2);
				camera.buffer.y = centre.y + (camera.buffer.stage.stageHeight / 2);
			}
			else
			{
				trace("not enabled");
			}
		}
	}
}