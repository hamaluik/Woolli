package com.blazingmammothgames.woolli.library.components;

import com.blazingmammothgames.woolli.core.Component;
import com.blazingmammothgames.woolli.util.Vector;

/**
 * ...
 * @author Kenton Hamaluik
 */
class C_Acceleration extends Component
{
	public var acceleration:Vector = Vector.zero;

	public function new(ax:Float, ay:Float) 
	{
		super();
		acceleration = new Vector(ax, ay);
	}
	
}