package com.blazingmammothgames.woolli.core;

import com.blazingmammothgames.woolli.core.mockups.MockComponentA;
import com.blazingmammothgames.woolli.core.mockups.MockComponentB;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import com.blazingmammothgames.woolli.core.EntityState;

class EntityStateTest 
{
	var es:EntityState; 
	
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
		es = new EntityState();
	}
	
	@After
	public function tearDown():Void
	{
		es = null;
	}
	
	@Test
	public function correctlyHasType():Void
	{
		es.addComponent(MockComponentA, null);
		Assert.isTrue(es.hasComponent(MockComponentA));
	}
	
	@Test
	public function correctlyDoesntHaveType():Void
	{
		Assert.isFalse(es.hasComponent(MockComponentA));
	}
	
	@Test
	public function cantAddPreexitingType():Void
	{
		es.addComponent(MockComponentA, null);
		var exceptionThrown:Bool = false;
		try
		{
			es.addComponent(MockComponentA, null);
		}
		catch (exc:ESException)
		{
			exceptionThrown = true;
		}
		Assert.isTrue(exceptionThrown);
	}
	
	@Test
	public function canInstantiateComponent():Void
	{
		var entity:Entity = new Entity();
		es.addComponent(MockComponentA, function(e:Entity):Component { return new MockComponentA(); } );
		var compA:MockComponentA = cast(es.instantiateInstance(entity, MockComponentA), MockComponentA);
		Assert.areNotEqual(null, compA);
	}
	
	@Test
	public function canInstantiateComponentWithModifiedData():Void
	{
		var entity:Entity = new Entity();
		es.addComponent(MockComponentA, function(e:Entity):Component { var comp:MockComponentA = new MockComponentA(); comp.dataA = 1; return comp; } );
		var compA:MockComponentA = cast(es.instantiateInstance(entity, MockComponentA), MockComponentA);
		Assert.areEqual(1, compA.dataA);
	}
	
	@Test
	public function correctlyHasInstantiator():Void
	{
		es.addComponent(MockComponentA, function(e:Entity):Component { return new MockComponentA(); });
		Assert.isTrue(es.hasInstantiator(MockComponentA));
	}
	
	@Test
	public function correctlyDoesntHaveInstantiator():Void
	{
		es.addComponent(MockComponentA, null);
		Assert.isFalse(es.hasInstantiator(MockComponentA));
	}
	
	@Test
	public function cantInstantiateComponentThatDoesntExist():Void
	{
		var exceptionThrown:Bool = false;
		try
		{
			es.instantiateInstance(null, MockComponentA);
		}
		catch (exc:ESException)
		{
			exceptionThrown = true;
		}
		Assert.isTrue(exceptionThrown);
	}
}