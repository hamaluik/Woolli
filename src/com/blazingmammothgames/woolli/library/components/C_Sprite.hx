package com.blazingmammothgames.woolli.library.components;

import com.blazingmammothgames.woolli.core.Component;
import com.blazingmammothgames.woolli.util.Vector;

/**
 * ...
 * @author Kenton Hamaluik
 */
class C_Sprite extends Component
{
	public var tileNumber:Int = 0;
	public var root:Vector = Vector.zero;

	public function new(tileNumber:Int, root:Vector)
	{
		super();
		this.tileNumber = tileNumber;
		this.root = root;
	}
	
}