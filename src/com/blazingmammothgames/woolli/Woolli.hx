package com.blazingmammothgames.woolli ;

import com.blazingmammothgames.woolli.demos.platformer.G_Platformer;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.Lib;
import thx.semver.Version;

/**
 * ...
 * @author Kenton Hamaluik
 */

class Woolli extends Sprite 
{
	var initialized:Bool;
	var splash:Splash;

	public static var version:Version = CompileTime.readFile("version.txt");

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

		splash = new Splash(this, new G_Platformer());
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
		Lib.current.stage.align = openfl.display.StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = openfl.display.StageScaleMode.NO_SCALE;
		Lib.current.addChild(new Woolli());
		trace(version);
	}
}
