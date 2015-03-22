package com.blazingmammothgames.woolli.util;

/**
 * ...
 * @author Kenton Hamaluik
 */
private class VectorRaw
{
	public var x:Float = 0;
	public var y:Float = 0;

	public function new(x:Float = 0, y:Float = 0) 
	{
		this.x = x;
		this.y = y;
	}
}

@:forward(x, y)
abstract Vector(VectorRaw) from VectorRaw to VectorRaw
{
	public function new(x:Float = 0, y:Float = 0) 
	{
		this = new VectorRaw(x, y);
	}
	
	public static var zero(get, never):Vector;
	private static inline function get_zero():Vector
	{
		return new Vector(0, 0);
	}
	
	public var length(get, never):Float;
	private inline function get_length():Float
	{
		return Math.sqrt((this.x * this.x) + (this.y * (this.y)));
	}
	
	public var normalized(get, never):Vector;
	private inline function get_normalized():Vector
	{
		var l:Float = length;
		if (l != 0)
			return new Vector(this.x / l, this.y / l);
		return new Vector(0, 0);
	}
	
	public var tangent(get, never):Vector;
	private inline function get_tangent():Vector
	{
		return new Vector(-this.y, this.x);
	}
	
	public static inline function squareDistance(a:Vector, b:Vector):Float
	{
		return (a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y);
	}
	
	public inline function isZero():Bool
	{
		return this.x == 0 && this.y == 0;
	}
	
	@:op(A * B)
	@:commutative
	public static inline function multiplyScalar(a:Vector, s:Float)
	{
		return new Vector(a.x * s, a.y * s);
	}
	
	@:op(A / B)
	public static inline function divideByScalar(a:Vector, s:Float)
	{
		return new Vector(a.x / s, a.y / s);
	}
	
	@:op(A + B)
	@:commutative
	public static inline function addScalar(a:Vector, b:Float)
	{
		return new Vector(a.x + b, a.y + b);
	}
	
	@:op(A - B)
	@:commutative
	public static inline function subtractScalar(a:Vector, b:Float)
	{
		return new Vector(a.x - b, a.y - b);
	}
	
	@:op(A + B)
	public static inline function addVectors(a:Vector, b:Vector)
	{
		return new Vector(a.x + b.x, a.y + b.y);
	}
	
	@:op(A - B)
	public static inline function subtractVectors(a:Vector, b:Vector)
	{
		return new Vector(a.x - b.x, a.y - b.y);
	}
	
	@:op(A * B)
	public static inline function crossProduct(a:Vector, b:Vector):Float
	{
		return (a.x * b.y - a.y * b.x);
	}
	
	@:op(A % B)
	public static inline function dotProduct(a:Vector, b:Vector):Float
	{
		return a.x * b.x + a.y * b.y;
	}

	/*
		calculates a x (b x c)
		note: (a x b) x c = -c x (a x b)
	*/
	public static inline function tripleCrossProduct(a:Vector, b:Vector, c:Vector):Vector
	{
		return new Vector(a.y * (b.x * c.y - b.y * c.x), -a.x * (b.x * c.y - b.y * c.x));
	}
	
	public static inline function roundToOne(a:Vector):Vector
	{
		return new Vector(Math.round(a.x), Math.round(a.y));
	}
	
	public function toString():String
	{
		return "[" + this.x + ", " + this.y + "]";
	}
}