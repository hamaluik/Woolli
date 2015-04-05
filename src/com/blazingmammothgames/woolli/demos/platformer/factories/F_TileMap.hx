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

using StringTools;

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
				line = line.trim();
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
						universe.addEntity(F_Platform.createPlatform(
							Std.parseFloat(object.att.x),
							Std.parseInt(object.att.y),
							Std.parseFloat(object.att.width),
							Std.parseInt(object.att.height)));
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
				// get the entities
				for (object in objectGroup.nodes.object)
				{
					switch(object.att.type)
					{
						case "player":
						{
							// get the location first
							var x = Std.parseFloat(object.att.x);
							var y = Std.parseFloat(object.att.y);
							var width = Std.parseFloat(object.att.width);
							var height = Std.parseFloat(object.att.height);
							
							// now create the entity
							var player:Entity = F_Player.createPlayer(new Vector(x + (width / 2), y + (height / 2)));
							universe.addEntity(player);
						}
					}
				}
			}
			// ignore anything else
		}
	}
}