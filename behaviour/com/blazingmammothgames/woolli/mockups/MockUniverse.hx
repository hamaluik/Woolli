package com.blazingmammothgames.woolli.mockups;

import com.blazingmammothgames.woolli.core.*;

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