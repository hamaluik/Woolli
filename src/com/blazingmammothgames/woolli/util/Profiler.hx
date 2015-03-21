package com.blazingmammothgames.woolli.util;
import haxe.ds.StringMap;
import haxe.Timer;
import openfl.display.Sprite;

/**
 * ...
 * @author Kenton Hamaluik
 */

private class Profile
{
	public var elapsedTime:Float = 0;
	public var startTime:Float = 0;
	
	public function new()
	{
		
	}
}
 
class Profiler
{
	public static var samplePeriod:Float = 1;
	private static var lastTime:Float = -1;
	private static var profiles:StringMap<Profile> = new StringMap<Profile>();
	
	public static function startProfile(name:String):Void
	{
		var profile:Profile = null;
		// if the profile already exists, get it
		if (profiles.exists(name))
			profile = profiles.get(name);
		else
		{
			profile = new Profile();
			profiles.set(name, profile);
		}
		if (lastTime < 0)
			#if (php || neko || cpp)
				lastTime = Sys.cpuTime();
			#else
				lastTime = Timer.stamp();
			#end
			
		#if (php || neko || cpp)
			profile.startTime = Sys.cpuTime();
		#else
			profile.startTime = Timer.stamp();
		#end
	}
	
	public static function endProfile(name:String):Void
	{
		#if (php || neko || cpp)
			var t:Float = Sys.cpuTime();
		#else
			var t:Float = Timer.stamp();
		#end
		if (!profiles.exists(name))
			throw "Profile '" + name + "' doesn't exist!";
		profiles.get(name).elapsedTime += t - profiles.get(name).startTime;
	}
	
	public static function drawProfiles(stage:Sprite):Void
	{
		// check to see if we need to reset the profiles
		#if (php || neko || cpp)
			var t:Float = Sys.cpuTime();
		#else
			var t:Float = Timer.stamp();
		#end
		
		// if there wasn't a last time, we don't have any profiles
		if (lastTime < 0)
			return;
			
		// show the profiles
		var totalTime:Float = 0;
		for (profile in profiles)
			totalTime += profile.elapsedTime;
		for (profileName in profiles.keys())
		{
			var et:Float = profiles.get(profileName).elapsedTime;
			var p:Float = totalTime == 0 ? 0 : (100 * (et / totalTime));
			p = Math.fround(p * 10) / 10;
			trace("P[" + profileName + "]: " + p + "% (" + et + "s)");
		}
			
		if (t - lastTime >= samplePeriod)
		{
			// reset the profiles
			lastTime = t;
			profiles = new StringMap<Profile>();
		}
	}
}