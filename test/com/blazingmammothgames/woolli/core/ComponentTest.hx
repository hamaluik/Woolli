package com.blazingmammothgames.woolli.core;

import com.blazingmammothgames.woolli.core.Component;
import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.core.mockups.MockComponentA;
import com.blazingmammothgames.woolli.core.mockups.MockSystemA;
import com.blazingmammothgames.woolli.core.mockups.MockUniverse;
import massive.munit.Assert;

class ComponentTest 
{
	var universe:MockUniverse;
	var system:MockSystemA;
	var entity:Entity;
	var component:MockComponentA;
	
	public function new() 
	{
		
	}
	
	@BeforeClass
	public function beforeClass():Void
	{
	}
	
	@AfterClass
	public function afterClass():Void
	{
	}
	
	@Before
	public function setup():Void
	{
		universe = new MockUniverse();
		system = new MockSystemA();
		universe.addSystem(system);
		entity = new Entity();
		component = new MockComponentA();
		entity.addComponent(component);
		universe.addEntity(entity);
	}
	
	@After
	public function tearDown():Void
	{
		component = null;
		entity = null;
		system = null;
		universe = null;
	}
	
	@Test public function universeCorrectlyMatchesSystemToEntityBasedOnComponent():Void
	{
		var sysEnt:Map<System, Array<Entity>> = universe.getSystemEntities();
		Assert.areEqual(0, sysEnt.get(system).indexOf(entity));
	}
	
	@Test
	public function universeRebindsSysEntsOnComponentEnabledChange():Void
	{
		component.enabled = false;
		var sysEnt:Map<System, Array<Entity>> = universe.getSystemEntities();
		Assert.areEqual( -1, sysEnt.get(system).indexOf(entity));
	}
	
	@Test
	public function componentCanSpanEntities():Void
	{
		var entity2:Entity = new Entity();
		entity2.addComponent(component);
		var comp2:MockComponentA = cast entity2.getComponentByType(MockComponentA);
		comp2.dataA = 24;
		Assert.areEqual(24, component.dataA);
	}
}