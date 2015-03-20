package com.blazingmammothgames.woolli ;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;

/**
 * ...
 * @author Kenton Hamaluik
 */

class Main extends Sprite 
{
	var initialized:Bool;
	var splash:Splash;

	/* ENTRY POINT */
	
	function resize(e) 
	{
		if (!initialized) init();
		// else (resize or orientation change)
	}
	
	function init() 
	{
		if (initialized) return;
		initialized = true;

		splash = new Splash(this/*, new G_WintersHere()*/);
	}

	/* SETUP */

	public function new() 
	{
		super();	
		addEventListener(Event.ADDED_TO_STAGE, added);
	}

	function added(e) 
	{
		removeEventListener(Event.ADDED_TO_STAGE, added);
		stage.addEventListener(Event.RESIZE, resize);
		#if ios
		haxe.Timer.delay(init, 100); // iOS 6
		#else
		init();
		#end
	}
	
	public static function main() 
	{
		// static entry point
		Lib.current.stage.align = flash.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Main());
	}
}
