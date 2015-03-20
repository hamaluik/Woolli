package 	com.blazingmammothgames.woolli.util;

/**
 * ...
 * @author Kenton Hamaluik
 */
class Random
{
	/** Return a random boolean value (true or false) */
	public static inline function bool():Bool
	{
		return Math.random() < 0.5;
	}

	/** Return a random integer between 'from' and 'to', inclusive. */
	public static inline function int(from:Int, to:Int):Int
	{
		return from + Math.floor(((to - from + 1) * Math.random()));
	}

	/** Return a random float between 'from' and 'to', inclusive. */
	public static inline function float(from:Float, to:Float):Float
	{
		return from + ((to - from) * Math.random());
	}
}