package com.blazingmammothgames.woolli.core ;
import openfl.display.Sprite;
import openfl.events.Event;

/**
 * @author Kenton Hamaluik
 */

interface IGame 
{
	public function onInit(sceneRoot:Sprite):Void;
	public function onFrame(event:Event):Void;
}