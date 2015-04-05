package com.blazingmammothgames.woolli.demos.platformer.components ;

import com.blazingmammothgames.woolli.core.Component;

/**
 * ...
 * @author Kenton Hamaluik
 */
class C_PlatformerController extends Component
{
	public var horizontal:Float = 0;
	public var jump:Bool = false;
	public var walkSpeed:Float = 0;
	public var jumpSpeed:Float = 0;

	public function new(walkSpeed:Float, jumpSpeed:Float) 
	{
		super();
		this.walkSpeed = walkSpeed;
		this.jumpSpeed = jumpSpeed;
	}
}