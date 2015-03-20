package com.blazingmammothgames.woolli.core;

import massive.munit.Assert;
import com.blazingmammothgames.woolli.core.EntityStateMachine;
import com.blazingmammothgames.woolli.core.Universe;
import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.core.mockups.MockComponentA;
import com.blazingmammothgames.woolli.core.mockups.MockComponentB;

class EntityStateMachineTest 
{
	var entity:Entity;
	var esm:EntityStateMachine; 
	
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
		entity = new Entity();
		esm = new EntityStateMachine(entity);
	}
	
	@After
	public function tearDown():Void
	{
		entity = null;
		esm = null;
	}
	
	@Test
	public function createStateIsChainable():Void
	{
		var esm2 = esm.createState("test");
		Assert.areSame(esm, esm2);
	}
	
	@Test
	public function ensureComponentIsChainable():Void
	{
		var esm2 = esm.createState("test").ensureComponent(Component, null);
		Assert.areSame(esm, esm2);
	}
	
	@Test
	public function canChangeStateWithoutComponents():Void
	{
		esm.createState("test");
		esm.changeState("test");
		Assert.areEqual("test", esm.currentState);
	}
	
	@Test
	public function cantChangeStatesToOneThatDoesntExist():Void
	{
		var exceptionThrown:Bool = false;
		try
		{
			esm.changeState("test");
		}
		catch (exc:ESException)
		{
			exceptionThrown = true;
		}
		Assert.isTrue(exceptionThrown);
	}
	
	@Test
	public function cantReuseStateName():Void
	{
		var exceptionThrown:Bool = false;
		esm.createState("test");
		try
		{
			esm.createState("test");
		}
		catch (exc:ESException)
		{
			exceptionThrown = true;
		}
		Assert.isTrue(exceptionThrown);
	}
	
	@Test
	public function changingStatesSwitchesComponents():Void
	{
		esm
			.createState("stateA").ensureComponent(MockComponentA, null)
			.createState("stateB").ensureComponent(MockComponentB, null);
		esm.changeState("stateA");
		esm.changeState("stateB");
		Assert.isFalse(entity.hasComponentType(MockComponentA));
		Assert.isTrue(entity.hasComponentType(MockComponentB));
	}
	
	@Test
	public function changingStatesWithInstantiatorsSwitchesInstances():Void
	{
		esm
			.createState("stateA").ensureComponent(MockComponentA, function(e:Entity) { var comp:MockComponentA = new MockComponentA(); comp.dataA = 1; return comp; } )
			.createState("stateB").ensureComponent(MockComponentA, function(e:Entity) { var comp:MockComponentA = new MockComponentA(); comp.dataA = 2; return comp; } );
		esm.changeState("stateA");
		esm.changeState("stateB");
		Assert.areEqual(2, cast(entity.getComponentByType(MockComponentA), MockComponentA).dataA);
	}
	
	@Test
	public function changingStatesWithoutInstantiatorDoesntSwitchInstance():Void
	{
		esm
			.createState("stateA").ensureComponent(MockComponentA, function(e:Entity) { var comp:MockComponentA = new MockComponentA(); comp.dataA = 1; return comp; } )
			.createState("stateB").ensureComponent(MockComponentA, null );
		esm.changeState("stateA");
		var comp:MockComponentA = cast(entity.getComponentByType(MockComponentA), MockComponentA);
		Assert.areEqual(1, comp.dataA);
		comp.dataA = 5;
		esm.changeState("stateB");
		Assert.areEqual(5, cast(entity.getComponentByType(MockComponentA), MockComponentA).dataA);
	}
}