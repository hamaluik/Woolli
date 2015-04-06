package com.blazingmammothgames.woolli.library.systems;

import com.blazingmammothgames.woolli.core.Demands;
import com.blazingmammothgames.woolli.core.System;
import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.library.components.C_AABB;
import com.blazingmammothgames.woolli.library.components.C_Collider;
import com.blazingmammothgames.woolli.library.components.C_DebugDraw;
import com.blazingmammothgames.woolli.library.components.C_GroundDetector;
import com.blazingmammothgames.woolli.library.components.C_Velocity;
import com.blazingmammothgames.woolli.util.EntityPair;
import com.blazingmammothgames.woolli.util.Vector;

/**
 * ...
 * @author Kenton Hamaluik
 */
class S_CollisionHandler extends System
{

	public function new() 
	{
		super(new Demands().requires(C_AABB).requires(C_Collider));
	}
	
	private function minkowskiDifference(a:C_AABB, b:C_AABB):C_AABB
	{
		var topLeft:Vector = a.min - b.max;
		var extents:Vector = a.extents + b.extents;
		return new C_AABB(topLeft + extents, extents);
	}
	
	private inline function layersCollide(a:C_Collider, b:C_Collider):Bool
	{
		return (a.collisionLayers & b.collidesWithLayers > 0) && (b.collisionLayers & a.collidesWithLayers > 0);
	}
	
	private function closestPointOnBoundsToPoint(min:Vector, max:Vector, point:Vector):Vector
	{
		var minDist:Float = Math.abs(point.x - min.x);
		var boundsPoint:Vector = new Vector(min.x, point.y);
		if (Math.abs(max.x - point.x) < minDist)
		{
			minDist = Math.abs(max.x - point.x);
			boundsPoint = new Vector(max.x, point.y);
		}
		if (Math.abs(max.y - point.y) < minDist)
		{
			minDist = Math.abs(max.y - point.y);
			boundsPoint = new Vector(point.x, max.y);
		}
		if (Math.abs(min.y - point.y) < minDist)
		{
			minDist = Math.abs(min.y - point.y);
			boundsPoint = new Vector(point.x, min.y);
		}
		return boundsPoint;
	}
	
	private function getRayIntersectionFractionOfFirstRay(originA:Vector, endA:Vector, originB:Vector, endB:Vector):Float
	{
		var r:Vector = endA - originA;
		var s:Vector = endB - originB;

		var numerator:Float = (originB - originA) * r;
		var denominator:Float = r * s;

		if (numerator == 0 && denominator == 0)
		{
			// the lines are co-linear
			// check if they overlap
			// todo: calculate intersection point
			return Math.POSITIVE_INFINITY;
		}
		if (denominator == 0)
		{
			// lines are parallel
			return Math.POSITIVE_INFINITY;
		}

		var u:Float = numerator / denominator;
		var t:Float = ((originB - originA) * s) / denominator;
		if ((t >= 0) && (t <= 1) && (u >= 0) && (u <= 1))
		{
			return t;
		}
		return Math.POSITIVE_INFINITY;
	}
	
	private function getRayIntersectionFraction(md:C_AABB, origin:Vector, direction:Vector):Float
	{
		var end:Vector = origin + direction;

		// for each of the AABB's four edges
		// calculate the minimum fraction of "direction"
		// in order to find where the ray FIRST intersects
		// the AABB (if it ever does)   
		var min:Vector = md.min;
		var max:Vector = md.max;
		var minT:Float = getRayIntersectionFractionOfFirstRay(origin, end, new Vector(min.x, min.y), new Vector(min.x, max.y));
		var x:Float;
		x = getRayIntersectionFractionOfFirstRay(origin, end, new Vector(min.x, max.y), new Vector(max.x, max.y));
		if (x < minT)
			minT = x;
		x = getRayIntersectionFractionOfFirstRay(origin, end, new Vector(max.x, max.y), new Vector(max.x, min.y));
		if (x < minT)
			minT = x;
		x = getRayIntersectionFractionOfFirstRay(origin, end, new Vector(max.x, min.y), new Vector(min.x, min.y));
		if (x < minT)
			minT = x;

		// ok, now we should have found the fractional component along the ray where we collided
		return minT;
	}
	
	override public function processEntities(dt:Float, entities:Array<Entity>):Void
	{
		for (entity in entities)
		{
			/*if (entity.hasComponentType(C_Velocity))
				cast(entity.getComponentByType(C_Velocity), C_Velocity).doMoveThisFrame = true;*/
			if (entity.hasComponentType(C_GroundDetector))
				cast(entity.getComponentByType(C_GroundDetector), C_GroundDetector).onGround = false;
		}
		//var processEntities:Array<Entity> = new Array<Entity>();
		var processedPairs:Array<EntityPair> = new Array<EntityPair>();
		
		for (entity in entities)
		{
			// get the required components
			var bounds:C_AABB = cast(entity.getComponentByType(C_AABB), C_AABB);
			var collider:C_Collider = cast(entity.getComponentByType(C_Collider), C_Collider);
			var vel:C_Velocity = null;
			if (entity.hasComponentType(C_Velocity))
				vel = cast(entity.getComponentByType(C_Velocity), C_Velocity);
			var groundDetector:C_GroundDetector = null;
			if (entity.hasComponentType(C_GroundDetector))
				groundDetector = cast(entity.getComponentByType(C_GroundDetector), C_GroundDetector);
				
			// loop over all other entities
			for (otherEntity in entities)
			{
				// we can't collide with ourself, so skip it
				if (otherEntity == entity)
					continue;
					
				// if we've already processed this pair, ignore it
				var alreadyProcessed:Bool = false;
				for (pair in processedPairs)
				{
					if (pair == new EntityPair(entity, otherEntity))
					{
						alreadyProcessed = true;
						break;
					}
				}
				if (alreadyProcessed)
				{
					continue;
				}
				processedPairs.push(new EntityPair(entity, otherEntity));
					
				var otherVel:C_Velocity = null;
				if (otherEntity.hasComponentType(C_Velocity))
					otherVel = cast(otherEntity.getComponentByType(C_Velocity), C_Velocity);
				// if both objects are static, ignore them
				if (vel == null && otherVel == null)
					continue;
				var otherGroundDetector:C_GroundDetector = null;
				if (otherEntity.hasComponentType(C_GroundDetector))
					otherGroundDetector = cast(otherEntity.getComponentByType(C_GroundDetector), C_GroundDetector);
					
				/*// skip any collisions we've already processed
				if (processEntities.indexOf(otherEntity) >= 0)
					continue;
				
				// keep track of which entities were processed this round
				processEntities.push(entity);*/
					
				// make sure the layers collide
				var otherCollider:C_Collider = cast(otherEntity.getComponentByType(C_Collider), C_Collider);
				if (!layersCollide(collider, otherCollider))
					continue;
				
				// get the bounds of the other box
				var otherBounds:C_AABB = cast(otherEntity.getComponentByType(C_AABB), C_AABB);
				
				// reset their colours
				if (entity.hasComponentType(C_DebugDraw))
					cast(entity.getComponentByType(C_DebugDraw), C_DebugDraw).colour = 0x0000ff;
				if (otherEntity.hasComponentType(C_DebugDraw))
					cast(otherEntity.getComponentByType(C_DebugDraw), C_DebugDraw).colour = 0x0000ff;
					
				// calculate the Minkowski difference for these two
				var md:C_AABB = minkowskiDifference(bounds, otherBounds);
				if (md.min.x <= 0 &&
					md.max.x >= 0 &&
					md.min.y <= 0 &&
					md.max.y >= 0)
				{
					// yup, these two are colliding!
					
					// deal with ground touching
					if (groundDetector != null && bounds.center.y + bounds.extents.y <= otherBounds.center.y - otherBounds.extents.y)
						groundDetector.onGround = true;
					if (otherGroundDetector != null && otherBounds.center.y + otherBounds.extents.y <= bounds.center.y - bounds.extents.y)
						otherGroundDetector.onGround = true;
					
					// set their colours
					if (entity.hasComponentType(C_DebugDraw))
						cast(entity.getComponentByType(C_DebugDraw), C_DebugDraw).colour = 0xff0000;
					if (otherEntity.hasComponentType(C_DebugDraw))
						cast(otherEntity.getComponentByType(C_DebugDraw), C_DebugDraw).colour = 0xff0000;
					
					// get the penetration vector
					var penetrationVector:Vector = closestPointOnBoundsToPoint(md.min, md.max, Vector.zero);
					
					// if the penetration vector is 0, don't bother with anything
					if (!penetrationVector.isZero())
					{
						/*if (vel != null) vel.doMoveThisFrame = false;
						if (otherVel != null) otherVel.doMoveThisFrame = false;*/
						
						// depending on the velocity capabilities of each, decide what to do
						if (vel != null && otherVel == null)
						{
							// zero out the normal velocity
							// (hit & stick)
							var tangent:Vector = penetrationVector.normalized.tangent;
							vel.velocity = Vector.dotProduct(vel.velocity, tangent) * tangent;
							
							// move the object out
							bounds.center -= penetrationVector;
						}
						else if (vel == null && otherVel != null)
						{
							// zero out the normal velocity
							// (hit & stick)
							var tangent:Vector = penetrationVector.normalized.tangent;
							otherVel.velocity = Vector.dotProduct(otherVel.velocity, tangent) * tangent;
							
							// move the other object out
							otherBounds.center += penetrationVector;
						}
						else
						{
							// zero out the normal velocity
							// (hit & stick)
							var tangent:Vector = penetrationVector.normalized.tangent;
							vel.velocity = Vector.dotProduct(vel.velocity, tangent) * tangent;
							otherVel.velocity = Vector.dotProduct(otherVel.velocity, tangent) * tangent;
							
							// move both objects
							bounds.center -= penetrationVector / 2;
							otherBounds.center += penetrationVector / 2;
						}
					}
				}
				else
				{
					// they are not currently colliding
					// but they might this frame!
					
					// calculate the relative motion of the two boxes
					var va:Vector = vel == null ? Vector.zero : vel.velocity;
					var vb:Vector = otherVel == null ? Vector.zero : otherVel.velocity;
					var relativeMotion:Vector = (vb - va) * dt;
					
					// ray-cast the relative motion vector against the Minkowsky AABB
					var h:Float = getRayIntersectionFraction(md, Vector.zero, relativeMotion);
					
					// check to see if a collision will happen this frame
					// getRayIntersectionFraction returns Math.POSITIVE_INFINITY if there is no intersection
					if(h < Math.POSITIVE_INFINITY)
					{
						// set their colours
						if (entity.hasComponentType(C_DebugDraw))
							cast(entity.getComponentByType(C_DebugDraw), C_DebugDraw).colour = 0x00ff00;
						if (otherEntity.hasComponentType(C_DebugDraw))
							cast(otherEntity.getComponentByType(C_DebugDraw), C_DebugDraw).colour = 0x00ff00;
						
						// yup, there WILL be a collision this frame
						// move the boxes appropriately
						bounds.center += va * dt * h;
						otherBounds.center += vb * dt * h;
						
						/*if (vel != null) vel.doMoveThisFrame = false;
						if (otherVel != null) otherVel.doMoveThisFrame = false;*/

						// zero the normal component of the velocity
						// (project the velocity onto the tangent of the relative velocities
						//  and only keep the projected component, tossing the normal component)
						var tangent:Vector = relativeMotion.normalized.tangent;
						if(vel != null) vel.velocity = Vector.dotProduct(vel.velocity, tangent) * tangent;
						if(otherVel != null) otherVel.velocity = Vector.dotProduct(otherVel.velocity, tangent) * tangent;
					}
				}
			}
		}
		
		/*for (entity in entities)
		{
			if (entity.hasComponentType(C_Velocity))
			{
				var v:C_Velocity = cast(entity.getComponentByType(C_Velocity), C_Velocity);
				if (v.doMoveThisFrame)
				{
					cast(entity.getComponentByType(C_AABB), C_AABB).center += v.velocity * dt;
				}
			}
		}*/
	}
}