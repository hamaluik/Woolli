package com.blazingmammothgames.woolli.core;
import haxe.CallStack;

/**
 * ...
 * @author Kenton Hamaluik
 */
class WoolliException
{
	public var message(default, null):String;
	public var canIgnore(default, null):Bool;

	public function new(message:String, canIgnore:Bool) 
	{
		this.message = message;
		this.canIgnore = canIgnore;
	}
	
	public function toString()
	{
		return "Woolli Exception: " + this.message + " " + (this.canIgnore ? "[can ignore]" : "[non-recoverable]");
	}
}