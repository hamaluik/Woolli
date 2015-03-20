package com.blazingmammothgames.woolli.core;

import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.core.Universe;

/**
 * ...
 * @author Kenton Hamaluik
 */
class Component
{
	public var enabled(default, set):Bool = true;
	
	function set_enabled(enabled:Bool):Bool
	{
		this.enabled = enabled;
		Universe.current.updateEntitiesWithComponent(this);
		return this.enabled;
	}

	public function new()
	{
	}
	
}