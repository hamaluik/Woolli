package com.blazingmammothgames.woolli.core;

import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.core.EntityStateMachine;
import com.blazingmammothgames.woolli.core.Component;
import com.blazingmammothgames.woolli.core.WoolliException;
import com.blazingmammothgames.woolli.mockups.*;

import buddy.*;
using buddy.Should;

/**
 * ...
 * @author Kenton Hamaluik
 */
class EntityStateMachineBehaviour extends BuddySuite
{
	public function new() 
	{
		describe("Using an EntityStateMachine", {
			var e:Entity;
			var esm:EntityStateMachine;
			before({
				e = new Entity();
				esm = e.stateMachine;
			});
			after({
				esm = null;
				e = null;
			});

			it("should provide a chainable interface to creating states", {
				esm.createState("test").should.be(esm);
			});
			it("should throw an exception if you try to add a component without being in a state", {
				esm.ensureComponent.bind(Component, null).should.throwType(WoolliException);
			});
			it("should provide a chainable interface to ensuring components", {
				esm.createState("test").ensureComponent.bind(Component, null).should.not.throwType(WoolliException);
			});
			it("should be able to change the state of the entity", {
				esm.createState("test1").createState("test2");
				esm.changeState("test1");
				esm.changeState("test2");
				esm.currentState.should.be("test2");
			});
			it("should change the composition of the entity's components when changing state", {
				esm
					.createState("test1")
						.ensureComponent(MockComponentA, null)
					.createState("test2")
						.ensureComponent(MockComponentB, null);
				esm.changeState("test1");
				e.hasComponentType(MockComponentA).should.be(true);
				e.hasComponentType(MockComponentB).should.be(false);
				esm.changeState("test2");
				e.hasComponentType(MockComponentA).should.be(false);
				e.hasComponentType(MockComponentB).should.be(true);
			});
			it("should throw an exception if you attempt to change to a state that doesn't exist", {
				esm.changeState.bind("test").should.throwType(WoolliException);
			});
			it("should allow you to define a custom instatiator function when ensuring components", {
				esm
					.createState("test")
						.ensureComponent(MockComponentA, function(e:Entity):Component {
							var c:MockComponentA = new MockComponentA();
							c.dataA = 4;
							return c;
						});
				esm.changeState("test");
				cast(e.getComponentByType(MockComponentA), MockComponentA).dataA.should.be(4);
			});
			it("should allow you to use a null instantiator to instantiate an empty component class", {
				esm
					.createState("test")
						.ensureComponent(MockComponentA, null);
				esm.changeState("test");
				cast(e.getComponentByType(MockComponentA), MockComponentA).dataA.should.be(42);
			});
			it("should allow you to retain an instance of a component when switching states if desired", {
				esm
					.createState("test1")
						.ensureComponent(MockComponentA, function(e:Entity):Component {
							var c:MockComponentA = new MockComponentA();
							c.dataA = 4;
							return c;
							})
					.createState("test2")
						.ensureComponent(MockComponentA, null, true);
				esm.changeState("test1");
				esm.changeState("test2");
				cast(e.getComponentByType(MockComponentA), MockComponentA).dataA.should.be(4);
			});
			it("should change the instance when an instantiator is null but retain is false", {
				esm
					.createState("test1")
						.ensureComponent(MockComponentA, function(e:Entity):Component {
							var c:MockComponentA = new MockComponentA();
							c.dataA = 4;
							return c;
							})
					.createState("test2")
						.ensureComponent(MockComponentA, null);
				esm.changeState("test1");
				esm.changeState("test2");
				cast(e.getComponentByType(MockComponentA), MockComponentA).dataA.should.be(42);
			});
		});
	}
}