package com.blazingmammothgames.woolli.core;

import com.blazingmammothgames.woolli.core.Component;

/**
 * ...
 * @author Kenton Hamaluik
 */
class Entity
{
	static private var nextID:Int = 0;
	public var id(default, null):Int = 0;
	public var enabled(default, set):Bool = true;
	private var components:Array<Component>;
	public var stateMachine(get, null):EntityStateMachine = null;
	
	function set_enabled(enabled:Bool):Bool
	{
		this.enabled = enabled;
		Universe.current.onEntityChange(this);
		return this.enabled;
	}
	
	function get_stateMachine():EntityStateMachine
	{
		if (stateMachine == null)
			stateMachine = new EntityStateMachine(this);
		return stateMachine;
	}

	public function new()
	{
		components = new Array<Component>();
		this.id = nextID;
		Entity.nextID++;
	}
	
	public function addComponent(component:Component, type:Class<Component> = null , updateUniverse:Bool = true):Void
	{
		if (type == null)
			type = Type.getClass(component);
		if (hasComponentType(type))
			throw new ESException("Entity already has component of type '" + type + "'!", true);
		components.push(component);
		if(updateUniverse)
			Universe.current.onEntityChange(this);
	}
	
	public function removeComponent(componentType:Class<Component>, updateUniverse:Bool = true):Void
	{
		var removed:Bool = false;
		for (component in components)
		{
			if (Type.getClass(component) == componentType)
			{
				components.remove(component);
				if(updateUniverse)
					Universe.current.onEntityChange(this);
				removed = true;
				break;
			}
		}
		if (!removed)
			throw new ESException("Entity didn't have a component of type '" + componentType + "'!", true);
	}
	
	public function replaceComponent(newComponent:Component, type:Class<Component> = null, updateUniverse:Bool = true):Void
	{
		if (type == null)
			type = Type.getClass(newComponent);
		if (!hasComponentType(type))
			throw new ESException("Entity doesn't have component of type '" + type + "'!", true);
		for (comp in components)
		{
			if (Type.getClass(comp) == type)
			{
				components.remove(comp);
				components.push(newComponent);
				if(updateUniverse)
					Universe.current.onEntityChange(this);
				return;
			}
		}
	}
	
	public function hasComponent(component:Component):Bool
	{
		for (comp in components)
			if (comp == component)
				return true;
		return false;
	}
	
	public function hasComponentType(componentType:Class<Component>):Bool
	{
		for (component in components)
			if (Type.getClass(component) == componentType && component.enabled)
				return true;
		return false;
	}
	
	public function getComponentByType(componentType:Class<Component>):Component
	{
		for (component in components)
			if (Type.getClass(component) == componentType)
				return component;
		throw new ESException("Entity doesn't have component of type '" + componentType + "'!", false);
		return null;
	}
	
	public function getComponentTypes():Array<Class<Component>>
	{
		var ret:Array<Class<Component>> = new Array<Class<Component>>();
		for (component in components)
			ret.push(Type.getClass(component));
		return ret;
	}
	
	public function onComponentEnabledChange(component:Component):Void
	{
		Universe.current.onEntityChange(this);
	}
}