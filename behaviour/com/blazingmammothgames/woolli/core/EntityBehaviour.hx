package com.blazingmammothgames.woolli.core;

import com.blazingmammothgames.woolli.core.Component;
import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.core.WoolliException;
import com.blazingmammothgames.woolli.mockups.MockComponentA;

import buddy.*;
using buddy.Should;

/**
 * ...
 * @author Kenton Hamaluik
 */
class EntityBehaviour extends BuddySuite
{
	public function new() 
	{
		describe("Using an Entity", {
			var e:Entity;
			before({
				e = new Entity();
			});
			after({
				e = null;
			});

			it("should increment the entity ID counter when it gets created", {
				var e2:Entity = new Entity();
				e2.id.should.be(e.id + 1);
			});
			it("should be able to be set active or inactive", {
				e.enabled = false;
				e.enabled = true;
			});
			it("shouldn't have any components on it when it is first created", {
				e.getComponentTypes().length.should.be(0);
			});
			it("should be able to have components be added to it", {
				var c:MockComponentA = new MockComponentA();
				e.addComponent(c);
			});
			it("should throw an exception if a component is added to it when it already has a component of that type", {
				var c1:MockComponentA = new MockComponentA();
				var c2:MockComponentA = new MockComponentA();
				e.addComponent(c1);
				e.addComponent.bind(c2).should.throwType(WoolliException);
			});
			it("should be able to get a component instance based on a given type", {
				var c:MockComponentA = new MockComponentA();
				e.addComponent(c);
				cast(e.getComponentByType(MockComponentA), MockComponentA).should.be(c);
			});
			it("should be able to remove components", {
				var c:MockComponentA = new MockComponentA();
				e.addComponent(c);
				e.removeComponent.bind(MockComponentA).should.not.throwType(WoolliException);
			});
			it("should throw an exception when attempting to remove a component that doesn't exist", {
				e.removeComponent.bind(MockComponentA).should.throwType(WoolliException);
			});
			it("should be able to distinguish between inherited and parent component classes", {
				e.addComponent(new Component());
				var c:MockComponentA = new MockComponentA();
				e.addComponent.bind(c).should.not.throwType(WoolliException);
				e.getComponentByType(MockComponentA).should.be(c);
			});
			it("should allow you to replace a component instance with a new one", {
				var c1:MockComponentA = new MockComponentA();
				var c2:MockComponentA = new MockComponentA();
				c1.dataA = 0;
				c2.dataA = 1;

				e.addComponent(c1);
				e.replaceComponent(c2);
				cast(e.getComponentByType(MockComponentA), MockComponentA).dataA.should.be(1);
			});
			it("should throw an exception if you try to replace a component that doesn't exist", {
				e.replaceComponent.bind(new MockComponentA()).should.throwType(WoolliException);
			});
			it("should automatically create the statemachine the first time it is called", {
				e.stateMachine.should.not.be(null);
			});
		});
	}
}