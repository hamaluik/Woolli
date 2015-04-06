package com.blazingmammothgames.woolli.library.systems;

import com.blazingmammothgames.woolli.core.Demands;
import com.blazingmammothgames.woolli.core.System;
import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.util.Vector;
import com.blazingmammothgames.woolli.library.components.C_AABB;
import com.blazingmammothgames.woolli.library.components.C_Sprite;
import com.blazingmammothgames.woolli.library.components.C_TileSheet;
import openfl.display.Sprite;
import openfl.display.Tilesheet;

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
			
			var x:Float = Math.fround(p.x - sprite.root.x + (sprite.flipped ? (bounds.size.x + (sprite.root.x * 2)) : 0));
			var y:Float = Math.fround(p.y - sprite.root.y);
			
			tileSheet.tileSheet.drawTiles(container.graphics, [x, y, sprite.tileNumber, (sprite.flipped ? -1 : 1) , 0, 0, 1], false, Tilesheet.TILE_TRANS_2x2 );
		}
	}
}