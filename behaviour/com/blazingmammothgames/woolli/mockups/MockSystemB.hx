package com.blazingmammothgames.woolli.mockups;

import com.blazingmammothgames.woolli.core.*;

/**
 * ...
 * @author Kenton Hamaluik
 */
@IgnoreCoverage
class MockSystemB extends System
{
	public var entityAdded:Bool = false;
	public var entityRemoved:Bool = false;
	public var entitiesProcessed:Bool = false;
	public var systemSuspended:Bool = false;
	public var systemResumed:Bool = false;
	
	public function new() 
	{
		super(new Demands().requires(MockComponentB));
	}
	
	override public function onEntityAdded(entity:Entity):Void
	{
		entityAdded = true;
	}
	
	override public function onEntityRemoved(entity:Entity):Void
	{
		entityRemoved = true;
	}
	
	override public function processEntities(dt:Float, entities:Array<Entity>):Void
	{
		entitiesProcessed = true;
	}
	
	override public function onSuspend():Void
	{
		systemSuspended = true;
	}
	
	override public function onResume():Void
	{
		systemResumed = true;
	}
}