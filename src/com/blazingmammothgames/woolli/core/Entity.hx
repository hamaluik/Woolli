package com.blazingmammothgames.woolli.core;

import com.blazingmammothgames.woolli.core.Component;
import haxe.ds.StringMap;

/**
 * ...
 * @author Kenton Hamaluik
 */
class Entity
{
	static private var nextID:Int = 0;
	public var id(default, null):Int = 0;
	public var enabled(default, set):Bool = true;
	private var components:StringMap<Component>;
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
		components = new StringMap<Component>();
		this.id = nextID;
		Entity.nextID++;
	}
	
	private static function compName(comp:Component):String
	{
		return typeName(Type.getClass(comp));
	}
	
	private static function typeName(type:Class<Component>):String
	{
		return Type.getClassName(type);
	}
	
	public function addComponent(component:Component, type:Class<Component> = null , updateUniverse:Bool = true):Void
	{
		if (type == null)
			type = Type.getClass(component);
		if (hasComponentType(type))
			throw new WoolliException("Entity already has component of type '" + type + "'!", true);
		components.set(typeName(type), component);
		if(updateUniverse)
			Universe.current.onEntityChange(this);
	}
	
	public function removeComponent(componentType:Class<Component>, updateUniverse:Bool = true):Void
	{
		if (!components.remove(typeName(componentType)))
			throw new WoolliException("Entity didn't have a component of type '" + componentType + "'!", true);
	}
	
	public function replaceComponent(newComponent:Component, type:Class<Component> = null, updateUniverse:Bool = true):Void
	{
		if (type == null)
			type = Type.getClass(newComponent);
		if (!hasComponentType(type))
			throw new WoolliException("Entity doesn't have component of type '" + type + "'!", true);
		components.set(typeName(type), newComponent);
		if(updateUniverse)
			Universe.current.onEntityChange(this);
	}
	
	public function hasComponent(component:Component):Bool
	{
		return hasComponentType(Type.getClass(component));
	}
	
	public function hasComponentType(componentType:Class<Component>):Bool
	{
		return components.exists(typeName(componentType));
	}
	
	public function getComponentByType(componentType:Class<Component>):Component
	{
		if (!hasComponentType(componentType))
			throw new WoolliException("Entity doesn't have component of type '" + componentType + "'!", false);
		return components.get(typeName(componentType));
	}
	
	public function getComponentTypes():Array<Class<Component>>
	{
		var ret:Array<Class<Component>> = new Array<Class<Component>>();
		for (k in components.keys())
			ret.push(Type.getClass(components.get(k)));
		return ret;
	}
	
	public function onComponentEnabledChange(component:Component):Void
	{
		Universe.current.onEntityChange(this);
	}
}