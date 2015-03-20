package com.blazingmammothgames.woolli.core;
import haxe.ds.StringMap;

/**
 * ...
 * @author Kenton Hamaluik
 */
class EntityState
{
	public var components(default, null):StringMap<ComponentProvider> = new StringMap<ComponentProvider>();

	public function new() 
	{
		
	}
	
	public function addComponent(componentType:Class<Component>, instantiator:Entity->Component):Void
	{
		if (components.exists(Type.getClassName(componentType)))
			throw new ESException("Can't add component type as it already exists!", true);
		components.set(Type.getClassName(componentType), new ComponentProvider(componentType, instantiator));
	}
	
	public function hasComponent(componentType:Class<Component>):Bool
	{
		return components.exists(Type.getClassName(componentType));
	}
	
	public function hasInstantiator(componentType:Class<Component>):Bool
	{
		return (components.exists(Type.getClassName(componentType))) && (components.get(Type.getClassName(componentType)).instantiator != null);
	}
	
	public function instantiateInstance(entity:Entity, componentType:Class<Component>):Component
	{
		if (!components.exists(Type.getClassName(componentType)))
			throw new ESException("Can't instantiate component that doesn't exist in this state!", false);
		var compProvider:ComponentProvider = components.get(Type.getClassName(componentType));
		return compProvider.instantiator(entity);
	}
	
	public function getComponentTypes():Array<Class<Component>>
	{
		var ret:Array<Class<Component>> = new Array<Class<Component>>();
		for (component in components)
			ret.push(component.type);
		return ret;
	}
	
}