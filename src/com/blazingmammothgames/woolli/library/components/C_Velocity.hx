package com.blazingmammothgames.woolli.library.components;

import com.blazingmammothgames.woolli.core.Component;
import com.blazingmammothgames.woolli.util.Vector;

/**
 * ...
 * @author Kenton Hamaluik
 */
class C_Velocity extends Component
{
	public var velocity:Vector = Vector.zero;
	public var doMoveThisFrame = true;

	public function new(vx:Float, vy:Float) 
	{
		super();
		velocity = new Vector(vx, vy);
	}
	
}