package com.blazingmammothgames.woolli.library.components;

import com.blazingmammothgames.woolli.core.Component;
import com.blazingmammothgames.woolli.util.Vector;
import openfl.Assets;
import openfl.display.BitmapData;
import openfl.display.Tilesheet;

/**
 * ...
 * @author Kenton Hamaluik
 */
class C_TileSheet extends Component
{
	public var tileSheet:Tilesheet = null;
	public var sheetSize:Vector = Vector.zero;
	public var tileSize:Float = 0;

	public function new(tileSheetPath:String, tileSize:Float)
	{
		super();
		
		var bmp:BitmapData = Assets.getBitmapData(tileSheetPath);
		this.tileSize = tileSize;
		sheetSize = new Vector(bmp.width / tileSize, bmp.height / tileSize);
		
		tileSheet = new Tilesheet(Assets.getBitmapData(tileSheetPath));
	}
	
}