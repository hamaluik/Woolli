package com.blazingmammothgames.woolli.core;

import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.core.Universe;
import com.blazingmammothgames.woolli.core.WoolliException;
import com.blazingmammothgames.woolli.mockups.*;

import buddy.*;
using buddy.Should;

/**
 * ...
 * @author Kenton Hamaluik
 */
class UniverseBehaviour extends BuddySuite
{
	public function new() 
	{
		describe("Using Universe", {
			var universe:MockUniverse;
			before({
				universe = new MockUniverse();
			});
			after({
				universe = null;
			});

			it("should allow you to add a system", {
				universe.addSystem.bind(new MockSystemA()).should.not.throwType(WoolliException);
			});
			it("should allow you to remove a system", {
				var sys:MockSystemA = new MockSystemA();
				universe.addSystem(sys);
				universe.removeSystem.bind(sys).should.not.throwType(WoolliException);
			});
			it("should throw an exception if you try to remove a non-existent system", {
				universe.removeSystem.bind(new MockSystemA()).should.throwType(WoolliException);
			});
			it("should allow you to add an entity", {
				universe.addEntity.bind(new Entity()).should.not.throwType(WoolliException);
			});
			it("should allow you to remove an entity", {
				var e:Entity = new Entity();
				universe.addEntity(e);
				universe.removeEntity.bind(e).should.not.throwType(WoolliException);
			});
			it("should throw an exception if you try to remove a non-existent entity", {
				universe.removeEntity.bind(new Entity()).should.throwType(WoolliException);
			});
			it("should process all enabled systems when it updates", {
				var sysA:MockSystemA = new MockSystemA();
				universe.addSystem(sysA);
				var sysB:MockSystemA = new MockSystemA();
				universe.addSystem(sysB);
				universe.onUpdate(0.5);
				sysA.entitiesProcessed.should.be(true);
				sysB.entitiesProcessed.should.be(true);
			});
			it("shouldn't process disabled systems when it updates", {
				var sysA:MockSystemA = new MockSystemA();
				universe.addSystem(sysA);
				var sysB:MockSystemA = new MockSystemA();
				universe.addSystem(sysB);
				sysB.enabled = false;
				universe.onUpdate(0.5);
				sysA.entitiesProcessed.should.be(true);
				sysB.entitiesProcessed.should.be(false);
			});
			it("should rebind all entities when a system is added", {
				var e:Entity = new Entity();
				e.addComponent(new MockComponentA());
				universe.addEntity(e);
				var sysA:MockSystemA = new MockSystemA();
				universe.addSystem(sysA);
				sysA.entityAdded.should.be(true);
			});
			it("should bind an entity when that entity is added", {
				var sysA:MockSystemA = new MockSystemA();
				universe.addSystem(sysA);
				var e:Entity = new Entity();
				e.addComponent(new MockComponentA());
				universe.addEntity(e);
				sysA.entityAdded.should.be(true);
			});
			it("should unbind an entity when that entity is removed", {
				var sysA:MockSystemA = new MockSystemA();
				universe.addSystem(sysA);
				var e:Entity = new Entity();
				e.addComponent(new MockComponentA());
				universe.addEntity(e);
				universe.removeEntity(e);
				sysA.entityRemoved.should.be(true);
			});
			it("should rebind an entity when the entity is disabled or re-enabled", {
				var sysA:MockSystemA = new MockSystemA();
				universe.addSystem(sysA);
				var e:Entity = new Entity();
				e.addComponent(new MockComponentA());
				universe.addEntity(e);
				e.enabled = false;
				sysA.entityRemoved.should.be(true);
			});
		});
	}
}