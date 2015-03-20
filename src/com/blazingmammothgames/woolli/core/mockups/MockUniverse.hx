package com.blazingmammothgames.woolli.core.mockups;

import com.blazingmammothgames.woolli.core.Universe;

/**
 * ...
 * @author Kenton Hamaluik
 */
class MockUniverse extends Universe
{
	public function new()
	{
		super();
		
	}
	
	public function getSystemEntities():Map<System, Array<Entity>>
	{
		return systemEntities;
	}
}