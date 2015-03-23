package com.blazingmammothgames.woolli.library.systems;

import com.blazingmammothgames.woolli.core.Demands;
import com.blazingmammothgames.woolli.core.System;
import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.library.components.C_AABB;
import openfl.display.Sprite;
import openfl.Vector;

@author("Kenton Hamaluik")
@description("Draws semi-transparent rectangles over axis-aligned bounding boxes for debug display.")
class S_DebugDraw extends System
{
	private var container:Sprite;
	private var colours:Array<Int> = new Array<Int>();

	public function new(root:Sprite) 
	{
		super(new Demands().requires(C_AABB));
		container = new Sprite();
		root.addChild(container);
		
		colours.push(0xff0000);
		colours.push(0x00ff00);
		colours.push(0x0000ff);
		colours.push(0xffff00);
		colours.push(0xff00ff);
		colours.push(0x00ffff);
	}
	
	override public function processEntities(dt:Float, entities:Array<Entity>):Void
	{
		container.graphics.clear();
		var ci:Int = 0;
		for (entity in entities)
		{
			var bounds:C_AABB = cast(entity.getComponentByType(C_AABB), C_AABB);
			
			container.graphics.beginFill(colours[ci], 0.5);
			container.graphics.drawRect(bounds.min.x, bounds.min.y, bounds.size.x, bounds.size.y);
			container.graphics.endFill();
			/*container.graphics.lineStyle(0.01, colours[ci]);
			container.graphics.moveTo(bounds.min.x, bounds.min.y);
			container.graphics.lineTo(bounds.max.x, bounds.min.y);
			container.graphics.lineTo(bounds.max.x, bounds.max.y);
			container.graphics.lineTo(bounds.min.x, bounds.max.y);
			container.graphics.lineTo(bounds.min.x, bounds.min.y);*/
			ci++;
			if (ci >= colours.length)
				ci = 0;
		}
		
		// draw the camera root
		#if flash
		container.graphics.beginFill(0xff0000);
		container.graphics.drawTriangles(Vector.fromArray([0.0, 1.0, 0.0, -1.0, 5.0, 0.0]));
		container.graphics.endFill();
		container.graphics.beginFill(0xff00);
		container.graphics.drawTriangles(Vector.fromArray([-1.0, 0.0, 1.0, 0.0, 0.0, 5.0]));
		container.graphics.endFill();
		container.graphics.beginFill(0x0000ff);
		container.graphics.drawCircle(0, 0, 1);
		container.graphics.endFill();
		#end
	}
}