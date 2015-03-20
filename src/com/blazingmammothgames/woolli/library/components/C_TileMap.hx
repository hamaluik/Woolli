package com.blazingmammothgames.woolli.library.components;

import com.blazingmammothgames.woolli.core.Component;
import com.blazingmammothgames.woolli.util.Vector;

/**
 * ...
 * @author Kenton Hamaluik
 */
class C_TileMap extends Component
{
	public var size:Vector = Vector.zero;
	public var bgLayers:Array<Array<Array<Int>>> = new Array<Array<Array<Int>>>();
	public var fgLayers:Array<Array<Array<Int>>> = new Array<Array<Array<Int>>>();

	public function new() 
	{
		super();
		
		
	}
}