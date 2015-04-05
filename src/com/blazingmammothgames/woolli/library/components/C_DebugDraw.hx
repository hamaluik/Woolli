package com.blazingmammothgames.woolli.library.components;

import com.blazingmammothgames.woolli.core.Component;

/**
 * ...
 * @author Kenton Hamaluik
 */
class C_DebugDraw extends Component
{
	public var colour:UInt = 0xff0000;

	public function new(?colour:UInt) 
	{
		super();
		if (colour != null) this.colour = colour;
	}
	
}