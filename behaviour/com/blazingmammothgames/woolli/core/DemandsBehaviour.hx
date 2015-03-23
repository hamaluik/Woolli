package com.blazingmammothgames.woolli.core;

import com.blazingmammothgames.woolli.core.Component;
import com.blazingmammothgames.woolli.core.WoolliException;
import com.blazingmammothgames.woolli.mockups.*;

import buddy.*;
using buddy.Should;

/**
 * ...
 * @author Kenton Hamaluik
 */
class DemandsBehaviour extends BuddySuite
{
	public function new() 
	{
		describe("Using Demands", {
			var demands:Demands;
			before({
				demands = new Demands();
			});
			after({
				demands = null;
			});

			it("should be able to chain-construct using requires", {
				demands.requires(Component).should.be(demands);
			});
			it("should be able to chain-construct using lacks", {
				demands.lacks(Component).should.be(demands);
			});
			it("should match an entity with at least one matching component", {
				var e:Entity = new Entity();
				e.addComponent(new MockComponentA());
				demands.requires(MockComponentA);
				demands.matchesEntity(e).should.be(true);
			});
			it("shouldn't match an entity that contains an undesired component", {
				var e:Entity = new Entity();
				e.addComponent(new MockComponentA());
				demands.lacks(MockComponentA);
				demands.matchesEntity(e).should.be(false);
			});
			it("should throw an exception if you try to add the same component twice", {
				demands.requires(MockComponentA).requires.bind(MockComponentA).should.throwType(WoolliException);
			});
			it("should throw an exception if you try to restrict the same component twice", {
				demands.lacks(MockComponentA).lacks.bind(MockComponentA).should.throwType(WoolliException);
			});
			it("should throw an exception if you try to restrict a component that has already been required", {
				demands.requires(MockComponentA).lacks.bind(MockComponentA).should.throwType(WoolliException);
			});
			it("should throw an exception if you try to require a component that has already been restricted", {
				demands.lacks(MockComponentA).requires.bind(MockComponentA).should.throwType(WoolliException);
			});
			it("should be able to match any entity when there are no requirements whatsoever", {
				var e1:Entity = new Entity();
				e1.addComponent(new MockComponentA());
				var e2:Entity = new Entity();
				demands.matchesEntity(e1).should.be(true);
				demands.matchesEntity(e2).should.be(true);
			});
			it("shouldn't match an entity if the entity is missing a required component", {
				var e1:Entity = new Entity();
				e1.addComponent(new Component());
				demands.requires(MockComponentA);
				demands.matchesEntity(e1).should.be(false);
			});
			it("shouldn't match an entity if the entity has a restricted component", {
				var e1:Entity = new Entity();
				e1.addComponent(new MockComponentA());
				demands.lacks(MockComponentA);
				demands.matchesEntity(e1).should.be(false);
			});
			it("shouldn't match an entity if the entity's component has been disabled", {
				var e:Entity = new Entity();
				var c:Component = new Component();
				e.addComponent(c);
				demands.requires(Component);
				c.enabled = false;
				demands.matchesEntity(e).should.be(false);
			});
		});
	}
}