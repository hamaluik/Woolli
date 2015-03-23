package com.blazingmammothgames.woolli.core;

/**
 * ...
 * @author Kenton Hamaluik
 */
class ComponentProvider
{
	public var type:Class<Component>;
	public var instantiator:Entity->Component;
	public var retainInstance:Bool = false;
	
	public function new(type:Class<Component>, instantiator:Entity->Component, retainInstance:Bool)
	{
		this.type = type;
		this.instantiator = instantiator;
		this.retainInstance = retainInstance;
	}
}