package com.blazingmammothgames.woolli.util;

import com.blazingmammothgames.woolli.core.Entity;

/**
 * ...
 * @author Kenton Hamaluik
 */
class EntityPair
{
	public var a:Entity;
	public var b:Entity;

	public function new(?a:Entity, ?b:Entity) 
	{
		this.a = a;
		this.b = b;
	}
	
	@:op(A == B)
	@:commutative
	public static inline function equal(A:EntityPair, B:EntityPair):Bool
	{
		return ((A.a == B.a && A.b == B.b) || (A.a == B.b && A.b == B.a));
	}
}