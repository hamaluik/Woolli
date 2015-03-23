package com.blazingmammothgames.woolli.library.systems;

import com.blazingmammothgames.woolli.core.Demands;
import com.blazingmammothgames.woolli.core.System;
import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.util.Vector;
import com.blazingmammothgames.woolli.library.components.C_AABB;
import com.blazingmammothgames.woolli.library.components.C_Sprite;
import com.blazingmammothgames.woolli.library.components.C_TileSheet;
import openfl.display.Sprite;

/**
 * ...
 * @author Kenton Hamaluik
 */
class S_SpriteLayer extends System
{
	private var container:Sprite;

	public function new(root:Sprite) 
	{
		super(new Demands().requires(C_Sprite).requires(C_AABB).requires(C_TileSheet));
		container = new Sprite();
		root.addChild(container);
	}
	
	override public function processEntities(dt:Float, entities:Array<Entity>):Void
	{
		container.graphics.clear();
		for (entity in entities)
		{
			var tileSheet:C_TileSheet = cast(entity.getComponentByType(C_TileSheet), C_TileSheet);
			var sprite:C_Sprite = cast(entity.getComponentByType(C_Sprite), C_Sprite);
			var bounds:C_AABB = cast(entity.getComponentByType(C_AABB), C_AABB);
			
			// draw it
			var p:Vector = Vector.roundToOne(bounds.min);
			tileSheet.tileSheet.drawTiles(container.graphics, [p.x - sprite.root.x, p.y - sprite.root.y, sprite.tileNumber]);
		}
	}
}