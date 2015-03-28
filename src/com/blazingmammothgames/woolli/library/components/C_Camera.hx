package com.blazingmammothgames.woolli.library.components;

import com.blazingmammothgames.woolli.core.Component;
import com.blazingmammothgames.woolli.util.Vector;
import openfl.display.Sprite;

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
	public static var current:C_Camera = null;
	public var buffer:Sprite = null;

	public function new(buffer:Sprite, zoom:Float, centre:Vector, clearColour:Int = 0x000000, followTarget:C_AABB = null)
	{
		super();
		this.buffer = buffer;
		this.zoom = zoom;
		this.centre = centre;
		this.clearColour = clearColour;
		this.followTarget = followTarget;
		current = this;
	}
}