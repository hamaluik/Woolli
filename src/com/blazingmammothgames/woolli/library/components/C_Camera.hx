package com.blazingmammothgames.woolli.library.components;

import com.blazingmammothgames.woolli.core.Component;
import com.blazingmammothgames.woolli.util.Vector;

/**
 * ...
 * @author Kenton Hamaluik
 */
class C_Camera extends Component
{
	public var zoom:Float = 4;
	public var centre:Vector = Vector.zero;
	public var clearColour:Int = 0x000000;
	public var followTarget:C_AABB = null;

	public function new(zoom:Float, centre:Vector, clearColour:Int = 0x000000, followTarget:C_AABB = null)
	{
		super();
		this.zoom = zoom;
		this.centre = centre;
		this.clearColour = clearColour;
		this.followTarget = followTarget;
	}
	
}