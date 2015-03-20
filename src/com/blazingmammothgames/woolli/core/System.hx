package com.blazingmammothgames.woolli.core;

import com.blazingmammothgames.woolli.core.Demands;

/**
 * ...
 * @author Kenton Hamaluik
 */
@IgnoreCover
class System
{
	public var demands(default, null):Demands;
	public var enabled:Bool = true;

	public function new(demands:Demands)
	{
		this.demands = demands;
	}
	
	public function onEntityAdded(entity:Entity):Void
	{
		
	}
	
	public function onEntityRemoved(entity:Entity):Void
	{
		
	}
	
	public function processEntities(dt:Float, entities:Array<Entity>):Void
	{
		
	}
	
	public function onSuspend():Void
	{
		
	}
	
	public function onResume():Void
	{
		
	}
}