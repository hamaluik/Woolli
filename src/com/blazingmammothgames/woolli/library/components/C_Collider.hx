package com.blazingmammothgames.woolli.library.components;

import com.blazingmammothgames.woolli.core.Component;
import com.blazingmammothgames.woolli.core.Entity;

/**
 * ...
 * @author Kenton Hamaluik
 */
class C_Collider extends Component
{
	public var collisionLayers:UInt = 1;
	public var collidesWithLayers:UInt = 1;

	public function new(collisionLayers:UInt, collidesWithLayers:UInt) 
	{
		super();
		this.collisionLayers = collisionLayers;
		this.collidesWithLayers = collidesWithLayers;
	}
}