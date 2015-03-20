package com.blazingmammothgames.woolli.library.components;

import com.blazingmammothgames.woolli.core.Component;
import com.blazingmammothgames.woolli.util.Vector;

/**
 * ...
 * @author Kenton Hamaluik
 */
class C_AABB extends Component
{
	public var center:Vector = new Vector();
	public var extents:Vector = new Vector();
	public var min(get, never):Vector;
	public function get_min()
	{
		return new Vector(center.x - extents.x, center.y - extents.y);
	}
	public var max(get, never):Vector;
	public function get_max()
	{
		return new Vector(center.x + extents.x, center.y + extents.y);
	}
	public var size(get, never):Vector;
	public function get_size()
	{
		return new Vector(extents.x * 2, extents.y * 2);
	}

	public function new(center:Vector, extents:Vector) 
	{
		super();
		this.center = center;
		this.extents = extents;
	}
}