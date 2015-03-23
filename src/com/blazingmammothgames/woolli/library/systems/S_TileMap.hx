package com.blazingmammothgames.woolli.library.systems;

import com.blazingmammothgames.woolli.core.Demands;
import com.blazingmammothgames.woolli.core.System;
import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.library.components.C_TileMap;
import com.blazingmammothgames.woolli.library.components.C_TileSheet;
import openfl.display.Sprite;

enum LayerSet {
	FG;
	BG;
}

/**
 * ...
 * @author Kenton Hamaluik
 */
class S_TileMap extends System
{
	private var container:Sprite;
	private var cached:Bool = false;
	private var layerSet:LayerSet;

	public function new(root:Sprite, layerSet:LayerSet) 
	{
		super(new Demands().requires(C_TileSheet).requires(C_TileMap));
		container = new Sprite();
		root.addChild(container);
		this.layerSet = layerSet;
	}
	
	override public function processEntities(dt:Float, entities:Array<Entity>):Void
	{
		// todo: determine if the cache needs to be updated
		
		// cache the map
		if (!cached)
		{
			container.graphics.clear();
			for (entity in entities)
			{
				var tileSheet:C_TileSheet = cast(entity.getComponentByType(C_TileSheet), C_TileSheet);
				var tileMap:C_TileMap = cast(entity.getComponentByType(C_TileMap), C_TileMap);
				
				var layers:Array<Array<Array<Int>>> = layerSet == LayerSet.BG ? tileMap.bgLayers : tileMap.fgLayers;
				for (layer in layers)
				{
					// contruct the tile data
					var tileData:Array<Float> = new Array<Float>();
					for (y in 0...Std.int(tileMap.size.y))
					{
						for (x in 0...Std.int(tileMap.size.x))
						{
							if (layer[y][x] >= 0)
							{
								tileData.push(Math.round(x * tileSheet.tileSize));
								tileData.push(Math.round(y * tileSheet.tileSize));
								tileData.push(layer[y][x]);
							}
						}
					}
					// draw the layer
					tileSheet.tileSheet.drawTiles(container.graphics, tileData);
				}
			}
			
			cached = true;
		}
	}
}