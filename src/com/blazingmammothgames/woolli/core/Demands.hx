package com.blazingmammothgames.woolli.core;

import com.blazingmammothgames.woolli.core.Component;

/**
 * ...
 * @author Kenton Hamaluik
 */
class Demands
{
	private var mustHaves:Array<Class<Component>>;
	private var mustNotHaves:Array<Class<Component>>;

	public function new() 
	{
		mustHaves = new Array<Class<Component>>();
		mustNotHaves = new Array<Class<Component>>();
	}
	
	public function requires(componentType:Class<Component>):Demands
	{
		if (inRequired(componentType))
			throw new WoolliException("Component already required!", true);
		if (inDenied(componentType))
			throw new WoolliException("Component already denied!", true);
		mustHaves.push(componentType);
		return this;
	}
	
	public function lacks(componentType:Class<Component>):Demands
	{
		if (inRequired(componentType))
			throw new WoolliException("Component already required!", true);
		if (inDenied(componentType))
			throw new WoolliException("Component already denied!", true);
		mustNotHaves.push(componentType);
		return this;
	}
	
	public function inRequired(componentType:Class<Component>):Bool
	{
		for (mustHave in mustHaves)
			if (mustHave == componentType)
				return true;
		return false;
	}
	
	public function inDenied(componentType:Class<Component>):Bool
	{
		for (mustNotHave in mustNotHaves)
			if (mustNotHave == componentType)
				return true;
		return false;
	}
	
	public function matchesEntity(entity:Entity):Bool
	{
		for (required in mustHaves)
		{
			if (!entity.hasComponentType(required))
				return false;
			if (!entity.getComponentByType(required).enabled)
				return false;
		}
		for (denied in mustNotHaves)
			if (entity.hasComponentType(denied))
				return false;
		
		return true;
	}
}