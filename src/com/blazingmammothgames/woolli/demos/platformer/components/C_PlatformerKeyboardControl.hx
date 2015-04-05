package com.blazingmammothgames.woolli.demos.platformer.components;

import com.blazingmammothgames.woolli.core.Component;

/**
 * ...
 * @author Kenton Hamaluik
 */
class C_PlatformerKeyboardControl extends Component
{
	public var leftKey:UInt;
	public var rightKey:UInt;
	public var jumpKey:UInt;

	public function new(leftKey:UInt, rightKey:UInt, jumpKey:UInt)
	{
		super();
		this.leftKey = leftKey;
		this.rightKey = rightKey;
		this.jumpKey = jumpKey;
	}
	
}