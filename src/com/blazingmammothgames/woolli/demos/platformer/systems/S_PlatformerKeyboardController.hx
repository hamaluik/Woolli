package com.blazingmammothgames.woolli.demos.platformer.systems;

import com.blazingmammothgames.woolli.core.Demands;
import com.blazingmammothgames.woolli.core.System;
import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.demos.platformer.components.C_PlatformerController;
import com.blazingmammothgames.woolli.demos.platformer.components.C_PlatformerKeyboardControl;
import openfl.events.KeyboardEvent;
import openfl.Lib;

/**
 * ...
 * @author Kenton Hamaluik
 */
class S_PlatformerKeyboardController extends System
{
	private var keys:Map<UInt, Bool> = new Map<UInt, Bool>();
	
	public function new() 
	{
		super(new Demands().requires(C_PlatformerController).requires(C_PlatformerKeyboardControl));
		
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
	
	override public function onDestroy():Void
	{
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
	}
	
	private function onKeyDown(event:KeyboardEvent):Void
	{
		keys.set(event.keyCode, true);
	}
	
	private function onKeyUp(event:KeyboardEvent):Void
	{
		keys.set(event.keyCode, false);
	}
	
	override public function processEntities(dt:Float, entities:Array<Entity>):Void
	{
		for (entity in entities)
		{
			var controller:C_PlatformerController = cast(entity.getComponentByType(C_PlatformerController), C_PlatformerController);
			var keyboardControl:C_PlatformerKeyboardControl = cast(entity.getComponentByType(C_PlatformerKeyboardControl), C_PlatformerKeyboardControl);
			
			if (keys.exists(keyboardControl.leftKey) && keys.get(keyboardControl.leftKey))
				controller.horizontal = -1;
			else
				controller.horizontal = 0;
			if (keys.exists(keyboardControl.rightKey) && keys.get(keyboardControl.rightKey))
				controller.horizontal += 1;
			controller.jump = keys.exists(keyboardControl.jumpKey) && keys.get(keyboardControl.jumpKey);
		}
	}
}