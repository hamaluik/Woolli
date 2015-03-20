package com.blazingmammothgames.woolli.core;

import com.blazingmammothgames.woolli.core.Entity;
import haxe.ds.StringMap;

/**
 * ...
 * @author Kenton Hamaluik
 */
class EntityStateMachine
{
	private var entity:Entity;
	public var currentState(default, null):String = "";
	private var lastStateAdded:String = "";
	private var entityStates:StringMap<EntityState> = new StringMap<EntityState>();

	public function new(entity:Entity)
	{
		this.entity = entity;
	}
	
	public function createState(name:String):EntityStateMachine
	{
		if (entityStates.exists(name))
			throw new WoolliException("Can't add state '" + name + "' as it already exists!", false);
		
		lastStateAdded = name;
		entityStates.set(name, new EntityState());
		return this;
	}
	
	public function ensureComponent(componentType:Class<Component>, instantiator:Entity->Component):EntityStateMachine
	{
		if (lastStateAdded == "")
			throw new WoolliException("Must create state before adding component!", false);
				
		entityStates.get(lastStateAdded).addComponent(componentType, instantiator);
		return this;
	}
	
	public function changeState(state:String):Void
	{
		if (!entityStates.exists(state))
			throw new WoolliException("Entity can't switch to state: '" + state + "' as it doesn't exist!", true);
		var es:EntityState = entityStates.get(state);
		for (componentType in entity.getComponentTypes())
		{
			if (es.hasComponent(componentType))
			{
				// we need to keep the component around
				// if there's an instantiator, reset the component
				if (es.hasInstantiator(componentType))
				{
					entity.replaceComponent(es.instantiateInstance(entity, componentType), componentType, false);
				}
				// otherwise, leave it alone
			}
			else
			{
				// we need to delete the component
				entity.removeComponent(componentType);
			}
		}
		
		// now go back and add any missing components
		for (componentType in es.getComponentTypes())
		{
			if (!entity.hasComponentType(componentType))
			{
				// it's missing a component!
				// add it!
				if (es.hasInstantiator(componentType))
				{
					// use the instantiator
					entity.addComponent(es.instantiateInstance(entity, componentType), componentType, false);
				}
				else
				{
					// no instantiator.
					// try to instantiate an empty class
					entity.addComponent(Type.createInstance(componentType, []), componentType, false);
				}
			}
		}
		
		// update the universe
		Universe.current.onEntityChange(entity);
		
		// update the current state
		currentState = state;
	}
}