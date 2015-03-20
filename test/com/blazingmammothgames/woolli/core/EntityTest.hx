package com.blazingmammothgames.woolli.core;

import com.blazingmammothgames.woolli.core.mockups.MockSystemA;
import com.blazingmammothgames.woolli.core.mockups.MockComponentA;
import com.blazingmammothgames.woolli.core.mockups.MockComponentB;
import haxe.Log;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.core.mockups.MockUniverse;

class EntityTest 
{
	var entity:Entity; 
	
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
	}
	
	@After
	public function tearDown():Void
	{
		entity = null;
	}
	
	@Test
	public function creatingEntityIncrementsID():Void
	{
		var entity2:Entity = new Entity();
		Assert.areEqual(entity.id + 1, entity2.id);
	}
	
	@Test
	public function settingInactiveStaysInactive():Void
	{
		entity.enabled = false;
		Assert.isFalse(entity.enabled);
	}
	
	@Test
	public function doesntHaveComponentTypeBeforeAdding():Void
	{
		Assert.isFalse(entity.hasComponentType(Component));
	}
	
	@Test
	public function hasComponentTypeAfterAdding():Void
	{
		entity.addComponent(new Component());
		Assert.isTrue(entity.hasComponentType(Component));
	}
	
	@Test
	public function addingAlreadyExistingComponentTypeThrowsException():Void
	{
		entity.addComponent(new Component());
		var exceptionThrown:Bool = false;
		try
		{
			entity.addComponent(new Component());
		}
		catch (e:WoolliException)
		{
			exceptionThrown = true;
		}
		Assert.isTrue(exceptionThrown);
	}
	
	@Test
	public function canGetByType():Void
	{
		var comp:Component = new Component();
		entity.addComponent(comp);
		Assert.areSame(comp, entity.getComponentByType(Component));
	}
	
	@Test
	public function cantGetByTypeIfNotAdded():Void
	{
		var exceptionThrown:Bool = false;
		try
		{
			entity.getComponentByType(Component);
		}
		catch (e:WoolliException)
		{
			exceptionThrown = true;
		}
		Assert.isTrue(exceptionThrown);
	}
	
	@Test
	public function canRemoveComponent():Void
	{
		var comp:Component = new Component();
		entity.addComponent(comp);
		entity.removeComponent(Component);
		Assert.isFalse(entity.hasComponentType(Component));
	}
	
	@Test
	public function cantRemoveNotAddedComponent():Void
	{
		var exceptionThrown:Bool = false;
		try
		{
			entity.removeComponent(Component);
		}
		catch (exception:WoolliException)
		{
			exceptionThrown = true;
		}
		Assert.isTrue(exceptionThrown);
	}
	
	@Test
	public function freshEntityHasNoComponentTypes():Void
	{
		var compTypes:Array<Class<Component>> = entity.getComponentTypes();
		Assert.areEqual(0, compTypes.length);
	}
	
	@Test
	public function entityTypesCorrectlyLists():Void
	{
		entity.addComponent(new MockComponentA());
		entity.addComponent(new MockComponentB());
		var compTypes:Array<Class<Component>> = entity.getComponentTypes();
		var hasA:Bool = false;
		var hasB:Bool = false;
		var hasOther:Bool = false;
		for (compType in compTypes)
		{
			if (Type.getClassName(compType) == "com.blazingmammothgames.woolli.core.mockups.MockComponentA")
			{
				hasA = true;
			}
			else  if (Type.getClassName(compType) == "com.blazingmammothgames.woolli.core.mockups.MockComponentB")
			{
				hasB = true;
			}
			else
			{
				hasOther = true;
			}
		}
		Assert.isTrue(hasA);
		Assert.isTrue(hasB);
		Assert.isFalse(hasOther);
	}
	
	@Test
	public function canAddInheritedComponent():Void
	{
		entity.addComponent(new Component());
		var compA:MockComponentA = new MockComponentA();
		entity.addComponent(compA);
		Assert.areSame(compA, entity.getComponentByType(MockComponentA));
	}
	
	@Test
	public function correctlyHasComponent():Void
	{
		var component:MockComponentA = new MockComponentA();
		entity.addComponent(component);
		Assert.isTrue(entity.hasComponent(component));
	}
	
	@Test
	public function correctlyDoesntHaveComponent():Void
	{
		Assert.isFalse(entity.hasComponent(new MockComponentA()));
	}
	
	@Test
	public function universeRebindsSysEntsOnComponentEnabledChange():Void
	{
		var universe:MockUniverse = new MockUniverse();
		var system:MockSystemA = new MockSystemA();
		universe.addSystem(system);
		var component:MockComponentA = new MockComponentA();
		entity.addComponent(component);
		universe.addEntity(entity);
		
		component.enabled = false;
		entity.onComponentEnabledChange(component);
		var sysEnt:Map<System, Array<Entity>> = universe.getSystemEntities();
		Assert.areEqual( -1, sysEnt.get(system).indexOf(entity));
	}
	
	@Test
	public function canReplaceComponentOfSameTypeWithDifferentInstance():Void
	{
		var compA:MockComponentA = new MockComponentA();
		var compB:MockComponentA = new MockComponentA();
		compA.dataA = 0;
		compB.dataA = 1;
		
		entity.addComponent(compA);
		entity.replaceComponent(compB);
		var compC:MockComponentA = cast entity.getComponentByType(MockComponentA);
		Assert.areEqual(1, compC.dataA);
	}
	
	@Test
	public function cantReplaceNonexistantComponent():Void
	{
		var exceptionThrown:Bool = false;
		try
		{
			entity.replaceComponent(new MockComponentA());
		}
		catch (exc:WoolliException)
		{
			exceptionThrown = true;
		}
		Assert.isTrue(exceptionThrown);
	}
	
	@Test
	public function doesntReplaceComponentIfSame():Void
	{
		var compA:MockComponentA = new MockComponentA();
		compA.dataA = 1;
		entity.addComponent(compA);
		entity.replaceComponent(compA);
		var compB:MockComponentA = cast entity.getComponentByType(MockComponentA);
		Assert.areEqual(1, compB.dataA);
	}
	
	@Test
	public function stateMachineAutoCreates():Void
	{
		var esm:EntityStateMachine = entity.stateMachine;
		Assert.areNotEqual(null, esm);
	}
}