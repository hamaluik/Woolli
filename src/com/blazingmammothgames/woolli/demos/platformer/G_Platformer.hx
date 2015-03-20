package com.blazingmammothgames.woolli.demos.platformer;
import com.blazingmammothgames.woolli.core.Component;
import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.core.Universe;
import com.blazingmammothgames.woolli.library.components.C_AABB;
import com.blazingmammothgames.woolli.library.systems.S_DebugDraw;
import com.blazingmammothgames.woolli.util.Vector;
import openfl.events.Event;

import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.core.Universe;
import com.blazingmammothgames.woolli.core.IGame;

import com.blazingmammothgames.woolli.util.CustomTrace;
import com.blazingmammothgames.woolli.util.Profiler;
import openfl.display.FPS;
import openfl.Lib;

import openfl.display.Sprite;
import haxe.Timer;

/**
 * ...
 * @author Kenton Hamaluik
 */
class G_Platformer implements IGame
{
	var lastTime:Float = 0;
	var playingUniverse:Universe;
	var sceneRoot:Sprite = null;
	var buffer:Sprite = null;

	public function new() 
	{
		
	}
	
	public function onInit(sceneRoot:Sprite):Void 
	{
		// store the scene root
		this.sceneRoot = sceneRoot;
		
		// enable custom trace
		CustomTrace.enableCustomTrace();
		
		// create a playing universe
		playingUniverse = new Universe();
		
		// create a buffer for everything to render into
		// (necessary for overlaid pixel effects)
		this.buffer = new Sprite();
		sceneRoot.addChild(buffer);
		
		// add all the systems
		#if debugdraw playingUniverse.addSystem(new S_DebugDraw(buffer)); #end
		
		// now create the entities
		var player:Entity = new Entity();
		player.stateMachine
			.createState("Idle")
				.ensureComponent(C_AABB, function(e:Entity):Component {
					return new C_AABB(new Vector(0, 0), new Vector(8, 10));
				});
		player.stateMachine.changeState("Idle");
		playingUniverse.addEntity(player);
		
		// an FPS counter in debug mode
		#if debugdraw sceneRoot.addChild(new FPS(Lib.current.stage.stageWidth - 50, 5, 0x000000)); #end
		
		// start
		Universe.current = playingUniverse;
		lastTime = Timer.stamp();
	}
	
	public function onFrame(event:Event):Void 
	{
		var time:Float = Timer.stamp();
		var dt:Float = time - lastTime;
		lastTime = time;
		Universe.current.onUpdate(dt);
		#if profiling
		CustomTrace.clear();
		Profiler.drawProfiles(sceneRoot);
		#end
	}
	
}