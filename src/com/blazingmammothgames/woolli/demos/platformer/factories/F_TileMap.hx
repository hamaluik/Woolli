package com.blazingmammothgames.woolli.demos.platformer.factories;

import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.core.Universe;
import com.blazingmammothgames.woolli.library.components.C_AABB;
import com.blazingmammothgames.woolli.library.components.C_Collider;
import com.blazingmammothgames.woolli.library.components.C_TileMap;
import com.blazingmammothgames.woolli.library.components.C_TileSheet;
import com.blazingmammothgames.woolli.util.Vector;
import haxe.io.Path;
import haxe.xml.Fast;
import openfl.Assets;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Kenton Hamaluik
 */
class F_TileMap
{
	public static function loadFromTMX(universe:Universe, path:String):Void
	{
		var tmx:String = Assets.getText(path);
		var xml:Xml = Xml.parse(tmx);
		var fastXML:Fast = new Fast(xml.firstElement());
		
		var mapWidth:Int = Std.parseInt(fastXML.att.width);
		var mapHeight:Int = Std.parseInt(fastXML.att.height);
		var tileSize:Int = Std.parseInt(fastXML.att.tilewidth); // square tiles for now
		
		var entity:Entity = new Entity();
		
		// load the tilesheet
		var imageNode:Fast = fastXML.node.tileset.node.image;
		var tileSetPath:String = Path.join([Path.directory(path), imageNode.att.source]);
		var tileSheet:C_TileSheet = new C_TileSheet(tileSetPath, tileSize);
		// load the grid
		for (y in 0...Std.int(tileSheet.sheetSize.y))
		{
			for (x in 0...Std.int(tileSheet.sheetSize.x))
			{
				tileSheet.tileSheet.addTileRect(new Rectangle((x * tileSize), (y * tileSize), tileSize, tileSize));
			}
		}
		entity.addComponent(tileSheet);
		
		// load the layers
		var tileMap:C_TileMap = new C_TileMap();
		tileMap.size = new Vector(mapWidth, mapHeight);
		
		// iterate over the layers
		var first:Bool = true;
		for (layerNode in fastXML.nodes.layer)
		{
			// extract the layer
			var layer:Array<Array<Int>> = new Array<Array<Int>>();
			var data:String = layerNode.node.data.innerData;
			
			// split the data into lines
			var dataLines:Array<String> = data.split("\n");
			for (line in dataLines)
			{
				if (line == "")
					continue;
				var tileIndices:Array<String> = line.split(",");
				var layerRow:Array<Int> = new Array<Int>();
				for (tileIndice in tileIndices)
				{
					if (Std.parseInt(tileIndice) == null)
						continue;
					layerRow.push(Std.parseInt(tileIndice) - 1);
				}
				layer.push(layerRow);
			}
			
			// determine if it's fg or bg
			if (StringTools.startsWith(layerNode.att.name, "bg"))
			{
				tileMap.bgLayers.push(layer);
			}
			else if (StringTools.startsWith(layerNode.att.name, "fg"))
			{
				tileMap.fgLayers.push(layer);
			}
		}
		
		entity.addComponent(tileMap);
		universe.addEntity(entity);
		
		// ok, the graphics for the map are loaded
		// now add the platforms and interactions
		for (objectGroup in fastXML.nodes.objectgroup)
		{
			if (objectGroup.att.name == "collisions")
			{
				// get the objects
				for (object in objectGroup.nodes.object)
				{
					// determine the type of object
					if (!object.elements.hasNext())
					{
						// it's an AABB
						var platform:Entity = new Entity();
						var x:Float = Std.parseFloat(object.att.x);
						var y:Float = Std.parseInt(object.att.y);
						var w:Float = Std.parseFloat(object.att.width);
						var h:Float = Std.parseInt(object.att.height);
						platform.addComponent(new C_AABB(new Vector(x + (w / 2), y + (h / 2)), new Vector(w / 2, h / 2)));
						platform.addComponent(new C_Collider((1 << 1), (1 << 0)));
						universe.addEntity(platform);
					}
					/*else if (object.elements.next().name == "polyline")
						trace("Found polyline!");
					else if (object.elements.next().name == "polygon")
						trace("Found polygon!");
					else if (object.elements.next().name == "ellipse")
						trace("Found ellipse!");*/
				}
			}
			else if (objectGroup.att.name == "zones")
			{
				// TODO
			}
			else if (objectGroup.att.name == "entities")
			{
				// TODO
			}
			// ignore anything else
		}
	}
}