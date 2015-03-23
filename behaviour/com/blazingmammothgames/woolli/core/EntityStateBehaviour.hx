package com.blazingmammothgames.woolli.core;

import com.blazingmammothgames.woolli.core.*;
import com.blazingmammothgames.woolli.mockups.*;

import buddy.*;
using buddy.Should;

/**
 * ...
 * @author Kenton Hamaluik
 */
class EntityStateBehaviour extends BuddySuite
{
	public function new() 
	{
		describe("Using EntityState", {
			var es:EntityState;
			before({ es = new EntityState(); });
			after({ es = null; });

			it("should allow you to add components based on their type", {
				es.addComponent(MockComponentA, null);
			});
			it("shouldn't report having a component if it doesn't", {
				es.hasComponent(MockComponentA).should.be(false);
			});
			it("should throw an exception if you attempt to add more than one component of the same type", {
				es.addComponent(MockComponentA, null);
				es.addComponent.bind(MockComponentA, null).should.throwType(WoolliException);
			});
			it("should allow you to check if the state has a component by type", {
				es.addComponent(MockComponentA, null);
				es.hasComponent(MockComponentA).should.be(true);
			});
			it("should be able to instantiate a component", {
				es.addComponent(MockComponentA, function(e:Entity):Component {
					var c:MockComponentA = new MockComponentA();
					c.dataA = 5;
					return c;
				});
				var e:Entity = new Entity();
				cast(es.instantiateInstance(e, MockComponentA), MockComponentA).dataA.should.be(5);
			});
			it("should be able to list the component types assosciated with a given state", {
				es.addComponent(MockComponentA, null);
				es.addComponent(MockComponentB, null);
				es.getComponentTypes().should.contain(MockComponentA);
				es.getComponentTypes().should.contain(MockComponentB);
				es.getComponentTypes().should.not.contain(Component);
			});
		});
	}
}