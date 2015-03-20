package com.blazingmammothgames.woolli.core;

import massive.munit.Assert;
import com.blazingmammothgames.woolli.core.Demands;
import com.blazingmammothgames.woolli.core.Component;
import com.blazingmammothgames.woolli.core.Universe;
import com.blazingmammothgames.woolli.core.mockups.MockComponentA;
import com.blazingmammothgames.woolli.core.mockups.MockComponentB;

class DemandsTest 
{
	var demands:Demands;
	
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
		demands = new Demands();
	}
	
	@After
	public function tearDown():Void
	{
		demands = null;
	}
	
	@Test
	public function addingRequiresReturnsDemandsInstance():Void
	{
		Assert.areEqual(demands.requires(Component), demands);
	}
	
	@Test
	public function addingLacksReturnsDemandsInstance():Void
	{
		Assert.areEqual(demands.lacks(Component), demands);
	}
	
	@Test
	public function addingRequiredIsInRequired():Void
	{
		demands.requires(Component);
		Assert.isTrue(demands.inRequired(Component));
	}
	
	@Test
	public function addingLacksIsInDenied():Void
	{
		demands.lacks(Component);
		Assert.isTrue(demands.inDenied(Component));
	}
	
	@Test
	public function requireIfAlreadyRequiredThrowsException():Void
	{
		demands.requires(Component);
		var exceptionThrown:Bool = false;
		try
		{
			demands.requires(Component);
		}
		catch (e:ESException)
		{
			exceptionThrown = true;
		}
		Assert.isTrue(exceptionThrown);
	}
	
	@Test
	public function lackIfAlreadyLacksThrowsException():Void
	{
		demands.lacks(Component);
		var exceptionThrown:Bool = false;
		try
		{
			demands.lacks(Component);
		}
		catch (e:ESException)
		{
			exceptionThrown = true;
		}
		Assert.isTrue(exceptionThrown);
	}
	
	@Test
	public function lackIfAlreadyRequiredThrowsException():Void
	{
		demands.requires(Component);
		var exceptionThrown:Bool = false;
		try
		{
			demands.lacks(Component);
		}
		catch (e:ESException)
		{
			exceptionThrown = true;
		}
		Assert.isTrue(exceptionThrown);
	}
	
	@Test
	public function requireIfAlreadyLackedThrowsException():Void
	{
		demands.lacks(Component);
		var exceptionThrown:Bool = false;
		try
		{
			demands.requires(Component);
		}
		catch (e:ESException)
		{
			exceptionThrown = true;
		}
		Assert.isTrue(exceptionThrown);
	}
	
	@Test
	public function correctlyMatchesEntityWithComponent():Void
	{
		demands.requires(MockComponentA);
		
		var entity:Entity = new Entity();
		entity.addComponent(new MockComponentA());
		Assert.isTrue(demands.matchesEntity(entity));
	}
	
	@Test
	public function correctlyMatchesEntityWithoutComponent():Void
	{
		demands.lacks(MockComponentA);
		
		var entity:Entity = new Entity();
		entity.addComponent(new MockComponentB());
		Assert.isTrue(demands.matchesEntity(entity));
	}
	
	@Test
	public function matchesEntityWithoutAnyComponentsWhenNoRequirements():Void
	{	
		var entity:Entity = new Entity();
		Assert.isTrue(demands.matchesEntity(entity));
	}
	
	@Test
	public function correctlyMatchesEntityWithMultipleComponents():Void
	{
		demands.requires(MockComponentA);
		
		var entity:Entity = new Entity();
		entity.addComponent(new MockComponentA());
		entity.addComponent(new MockComponentB());
		Assert.isTrue(demands.matchesEntity(entity));
	}
	
	@Test
	public function correctlyDoesntMatchEntityWithDeniedComponent():Void
	{
		demands.lacks(MockComponentA);
		
		var entity:Entity = new Entity();
		entity.addComponent(new MockComponentA());
		entity.addComponent(new MockComponentB());
		Assert.isFalse(demands.matchesEntity(entity));
	}
	
	@Test
	public function doesntMatchEntityWithDisabledComponent():Void
	{
		demands.requires(MockComponentA);
		
		var entity:Entity = new Entity();
		var component:MockComponentA = new MockComponentA();
		component.enabled = false;
		entity.addComponent(component);
		Assert.isFalse(demands.matchesEntity(entity));
	}
}