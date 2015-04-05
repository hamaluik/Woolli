package com.blazingmammothgames.woolli.demos.platformer;
import com.blazingmammothgames.woolli.core.Component;
import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.core.GameStateMachine;
import com.blazingmammothgames.woolli.core.Universe;
import com.blazingmammothgames.woolli.demos.platformer.factories.F_TileMap;
import com.blazingmammothgames.woolli.demos.platformer.systems.S_PlatformerController;
import com.blazingmammothgames.woolli.demos.platformer.systems.S_PlatformerKeyboardController;
import com.blazingmammothgames.woolli.demos.platformer.systems.S_PlayerAnimator;
import com.blazingmammothgames.woolli.library.components.C_AABB;
import com.blazingmammothgames.woolli.library.components.C_Camera;
import com.blazingmammothgames.woolli.library.systems.S_Acceleration;
import com.blazingmammothgames.woolli.library.systems.S_Animator;
import com.blazingmammothgames.woolli.library.systems.S_Camera;
import com.blazingmammothgames.woolli.library.systems.S_CollisionHandler;
import com.blazingmammothgames.woolli.library.systems.S_DebugDraw;
import com.blazingmammothgames.woolli.library.systems.S_SpriteLayer;
import com.blazingmammothgames.woolli.library.systems.S_TileMap;
import com.blazingmammothgames.woolli.library.systems.S_Velocity;
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
	var sceneRoot:Sprite = null;
	var buffer:Sprite = null;
	
	var gsm:GameStateMachine = new GameStateMachine();

	public function new() 
	{
		
	}
	
	public function onInit(sceneRoot:Sprite):Void 
	{
		// store the scene root
		this.sceneRoot = sceneRoot;
		
		// enable custom trace
		CustomTrace.enableCustomTrace(null, 0xffffff);
		
		// create a buffer for everything to render into
		// (necessary for overlaid pixel effects)
		this.buffer = new Sprite();
		sceneRoot.addChild(buffer);
		
		// add all the systems
		gsm.addUniverse("test", function():Universe {
			var universe:Universe = new Universe();
			
			// add the systems
			universe.addSystem(new S_PlatformerKeyboardController());
			universe.addSystem(new S_PlatformerController());
			universe.addSystem(new S_Acceleration());
			universe.addSystem(new S_Velocity());
			universe.addSystem(new S_CollisionHandler());
			universe.addSystem(new S_Animator());
			universe.addSystem(new S_PlayerAnimator());
			universe.addSystem(new S_Camera());
			universe.addSystem(new S_TileMap(buffer, LayerSet.BG));
			universe.addSystem(new S_SpriteLayer(buffer));
			universe.addSystem(new S_TileMap(buffer, LayerSet.FG));
			#if debugdraw universe.addSystem(new S_DebugDraw(buffer)); #end
			
			// load the tilemap
			F_TileMap.loadFromTMX(universe, "assets/demos/platformer/levels/level0.tmx");
			
			// create a camera
			var camera:Entity = new Entity();
			camera.addComponent(new C_Camera(buffer, 4, new Vector(104, 40), 0x000000));
			universe.addEntity(camera);
			
			return universe;
		});
		
		// an FPS counter in debug mode
		#if debugdraw sceneRoot.addChild(new FPS(Lib.current.stage.stageWidth - 50, 5, 0xffffff)); #end
		
		// start
		gsm.switchUniverse("test");
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