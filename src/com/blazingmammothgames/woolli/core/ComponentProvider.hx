package com.blazingmammothgames.woolli.core;

/**
 * ...
 * @author Kenton Hamaluik
 */
class ComponentProvider
{
	public var type:Class<Component>;
	public var instantiator:Entity->Component;
	
	public function new(type:Class<Component>, instantiator:Entity->Component)
	{
		this.type = type;
		this.instantiator = instantiator;
	}
}