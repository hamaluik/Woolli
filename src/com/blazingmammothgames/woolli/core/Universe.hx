package com.blazingmammothgames.woolli.core;

import com.blazingmammothgames.woolli.core.System;
import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.util.Profiler;

/**
 * ...
 * @author Kenton Hamaluik
 */
class Universe
{
	private var systems:Array<System>;
	private var entities:Array<Entity>;
	private var systemEntities:Map<System, Array<Entity>>;
	public static var current:Universe = null;
	
	public function new() 
	{
		systems = new Array<System>();
		entities = new Array<Entity>();
		systemEntities = new Map<System, Array<Entity>>();
		current = this;
	}
	
	public function systemExists(systemType:Class<System>):Bool
	{
		for (system in systems)
			if (Type.getClass(system) == systemType)
				return true;
		return false;
	}
	
	public function addSystem(system:System):Void
	{
		/*if (!systemExists(Type.getClass(system)))
		{
			systems.push(system);
			systemEntities.set(system, new Array<Entity>());
		}
		else
			throw new ESException("System already existed!", true);*/
		// actually, allow multiple systems of the same type
		systems.push(system);
		systemEntities.set(system, new Array<Entity>());
	}
	
	public function removeSystem(system:System):Void
	{
		if (!systems.remove(system)) {
			throw new ESException("System didn't exist!", true);
		}
		if (systemEntities.exists(system))
			systemEntities.remove(system);
	}
	
	public function entityExists(entity:Entity):Bool
	{
		for (ent in entities)
			if (ent == entity)
				return true;
		return false;
	}
	
	public function addEntity(entity:Entity):Void
	{
		if (!entityExists(entity))
		{
			entities.push(entity);
			onEntityChange(entity);
		}
		else
			throw new ESException("Entity already existed!", true);
	}
	
	public function removeEntity(entity:Entity):Void
	{
		if (!entities.remove(entity))
			throw new ESException("Couldn't remove entity as it wasn't registered!", true);
		entity.enabled = false;
		onEntityChange(entity);
		entity = null;
	}
	
	public function updateEntitiesWithComponent(component:Component):Void
	{
		var componentType:Class<Component> = Type.getClass(component);
		for (entity in entities)
		{
			if (entity.hasComponent(component))
			{
				onEntityChange(entity);
			}
		}
	}
	
	public function getEntitiesWithDemands(demands:Demands):Array<Entity>
	{
		var ret:Array<Entity> = new Array<Entity>();
		for (entity in entities)
		{
			if (demands.matchesEntity(entity))
			{
				ret.push(entity);
			}
		}
		return ret;
	}
	
	public function onEntityChange(entity:Entity):Void
	{
		for (system in systems)
		{
			var entityExisted:Bool = false;
			for (ent in systemEntities.get(system))
			{
				if (ent == entity)
				{
					entityExisted = true;
				}
			}
			
			// if it didn't exist and it does match, add it
			if (!entityExisted && entity.enabled && system.demands.matchesEntity(entity))
			{
				systemEntities.get(system).push(entity);
				system.onEntityAdded(entity);
			}
			// if it does exist and it no longer matches, remove it
			else if (entityExisted && (!entity.enabled || !system.demands.matchesEntity(entity) ))
			{
				systemEntities.get(system).remove(entity);
				system.onEntityRemoved(entity);
			}
		}
	}
	
	public function onUpdate(dt:Float):Void
	{
		for (system in systems)
		{
			if (system.enabled)
			{
				#if profiling
				Profiler.startProfile(Type.getClassName(Type.getClass(system)));
				#end
				system.processEntities(dt, systemEntities.get(system));
				#if profiling
				Profiler.endProfile(Type.getClassName(Type.getClass(system)));
				#end
			}
		}
	}
	
	public function suspend():Void
	{
		for (system in systems)
		{
			system.onSuspend();
		}
	}
	
	public function resume():Void
	{
		for (system in systems)
		{
			system.onResume();
		}
	}
}