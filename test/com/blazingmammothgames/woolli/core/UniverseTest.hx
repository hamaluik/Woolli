package com.blazingmammothgames.woolli.core;

import com.blazingmammothgames.woolli.core.mockups.MockComponentA;
import com.blazingmammothgames.woolli.core.mockups.MockComponentB;
import com.blazingmammothgames.woolli.core.mockups.MockUniverse;
import massive.munit.Assert;
import com.blazingmammothgames.woolli.core.Universe;
import com.blazingmammothgames.woolli.core.ESException;
import com.blazingmammothgames.woolli.core.mockups.MockSystemA;
import com.blazingmammothgames.woolli.core.mockups.MockSystemB;
import com.blazingmammothgames.woolli.core.Entity;

class UniverseTest 
{
	var universe:Universe; 
	
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
		universe = new Universe();
	}
	
	@After
	public function tearDown():Void
	{
		universe = null;
	}
	
	@Test
	public function canAddSystem():Void
	{
		universe.addSystem(new MockSystemA());
		Assert.isTrue(universe.systemExists(MockSystemA));
	}
	
	@Test
	public function systemDoesntExistWithoutAdding():Void
	{
		try
		{
			Assert.isFalse(universe.systemExists(MockSystemA));
		}
	}
	
	@Test
	public function canRemoveSystem():Void
	{
		var system:MockSystemA = new MockSystemA();
		universe.addSystem(system);
		universe.removeSystem(system);
		Assert.isFalse(universe.systemExists(MockSystemA));
	}
	
	@Test
	public function cantRemoveNonExistantSystem():Void
	{
		var exceptionThrown:Bool = false;
		try
		{
			universe.removeSystem(new MockSystemA());
		}
		catch(exception:ESException)
		{
			exceptionThrown = true;
		}
		Assert.isTrue(exceptionThrown);
	}
	
	@Test
	public function canAddEntity():Void
	{
		var entity = new Entity();
		universe.addEntity(entity);
		Assert.isTrue(universe.entityExists(entity));
	}
	
	@Test
	public function entityDoesntExistWithoutAdding():Void
	{
		Assert.isFalse(universe.entityExists(new Entity()));
	}
	
	@Test
	public function canRemoveEntity():Void
	{
		var entity:Entity = new Entity();
		universe.addEntity(entity);
		universe.removeEntity(entity);
		Assert.isFalse(universe.entityExists(entity));
	}
	
	@Test
	public function cantRemoveNonExistantEntity():Void
	{
		var exceptionThrown:Bool = false;
		try
		{
			universe.removeEntity(new Entity());
		}
		catch(exception:ESException)
		{
			exceptionThrown = true;
		}
		Assert.isTrue(exceptionThrown);
	}
	
	@Test
	public function processesAllSystemsOnUpdate():Void
	{
		var systemA:MockSystemA = new MockSystemA();
		var systemB:MockSystemB = new MockSystemB();
		universe.addSystem(systemA);
		universe.addSystem(systemB);
		universe.onUpdate(0.1);
		Assert.isTrue(systemA.entitiesProcessed && systemB.entitiesProcessed);
	}
	
	@Test
	public function doesntProcessDisabledSystems():Void
	{
		var systemA:MockSystemA = new MockSystemA();
		var systemB:MockSystemB = new MockSystemB();
		universe.addSystem(systemA);
		universe.addSystem(systemB);
		systemB.enabled = false;
		universe.onUpdate(0.1);
		Assert.isTrue(systemA.entitiesProcessed);
		Assert.isFalse(systemB.entitiesProcessed);
	}
	
	@Test
	public function rebindsEntitiesOnSystemAdd():Void
	{
		var mockUniverse:MockUniverse = new MockUniverse();
		var system:MockSystemA = new MockSystemA();
		mockUniverse.addSystem(system);
		var sysEnt:Map<System, Array<Entity>> = mockUniverse.getSystemEntities();
		Assert.isTrue(sysEnt.exists(system));
	}
	
	@Test
	public function rebindsEntityOnAdd():Void
	{
		var mockUniverse:MockUniverse = new MockUniverse();
		var systemA:MockSystemA = new MockSystemA();
		mockUniverse.addSystem(systemA);
		var entity:Entity = new Entity();
		entity.addComponent(new MockComponentA());
		mockUniverse.addEntity(entity);
		var sysEnt:Map<System, Array<Entity>> = mockUniverse.getSystemEntities();
		Assert.areEqual(0, sysEnt.get(systemA).indexOf(entity));
	}
	
	@Test
	public function rebindsEntityOnRemove():Void
	{
		var mockUniverse:MockUniverse = new MockUniverse();
		var systemA:MockSystemA = new MockSystemA();
		mockUniverse.addSystem(systemA);
		var entity:Entity = new Entity();
		mockUniverse.addEntity(entity);
		mockUniverse.removeEntity(entity);
		var sysEnt:Map<System, Array<Entity>> = mockUniverse.getSystemEntities();
		Assert.areEqual(-1, sysEnt.get(systemA).indexOf(entity));
	}
	
	@Test
	public function rebindsEntitiesOnEntityEnabledChange():Void
	{
		var mockUniverse:MockUniverse = new MockUniverse();
		var systemA:MockSystemA = new MockSystemA();
		mockUniverse.addSystem(systemA);
		var entity:Entity = new Entity();
		entity.addComponent(new MockComponentA());
		mockUniverse.addEntity(entity);
		
		var sysEnt:Map<System, Array<Entity>> = mockUniverse.getSystemEntities();
		Assert.areEqual(0, sysEnt.get(systemA).indexOf(entity));
		entity.enabled = false;
		sysEnt = mockUniverse.getSystemEntities();
		Assert.areEqual(-1, sysEnt.get(systemA).indexOf(entity));
	}
	
	@Test
	public function updatesEntitiesWithComponent():Void
	{
		var uni:MockUniverse = new MockUniverse();
		var system:MockSystemA = new MockSystemA();
		var ent1:Entity = new Entity();
		var ent2:Entity = new Entity();
		var comp:MockComponentA = new MockComponentA();
		ent1.addComponent(comp);
		ent2.addComponent(comp);
		uni.addSystem(system);
		uni.addEntity(ent1);
		uni.addEntity(ent2);
		
		var s1:String = uni.getSystemEntities().toString();
		ent2.enabled = false;
		uni.updateEntitiesWithComponent(comp);
		var s2:String = uni.getSystemEntities().toString();
		Assert.areNotEqual(s1, s2);
	}
	
	@Test
	public function canGetEntitiesUsingDemands():Void
	{
		var entity1:Entity = new Entity();
		entity1.addComponent(new MockComponentA());
		var entity2:Entity = new Entity();
		entity2.addComponent(new MockComponentA());
		entity2.addComponent(new MockComponentB());
		universe.addEntity(entity1);
		universe.addEntity(entity2);
		
		var demands:Demands = new Demands().requires(MockComponentA).lacks(MockComponentB);
		var arr:Array<Entity> = universe.getEntitiesWithDemands(demands);
		Assert.areEqual(1, arr.length);
		Assert.areSame(entity1, arr[0]);
	}
}