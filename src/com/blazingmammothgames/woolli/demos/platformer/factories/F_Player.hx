package com.blazingmammothgames.woolli.demos.platformer.factories;

import com.blazingmammothgames.woolli.core.Component;
import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.demos.platformer.components.C_PlatformerController;
import com.blazingmammothgames.woolli.demos.platformer.components.C_PlatformerKeyboardControl;
import com.blazingmammothgames.woolli.library.components.C_AABB;
import com.blazingmammothgames.woolli.library.components.C_Acceleration;
import com.blazingmammothgames.woolli.library.components.C_Animated;
import com.blazingmammothgames.woolli.library.components.C_Collider;
import com.blazingmammothgames.woolli.library.components.C_DebugDraw;
import com.blazingmammothgames.woolli.library.components.C_GroundDetector;
import com.blazingmammothgames.woolli.library.components.C_Sprite;
import com.blazingmammothgames.woolli.library.components.C_TileSheet;
import com.blazingmammothgames.woolli.library.components.C_Velocity;
import com.blazingmammothgames.woolli.util.Vector;
import openfl.ui.Keyboard;
import openfl.geom.Rectangle;

/**
 * ...
 * @author Kenton Hamaluik
 */
class F_Player
{
	public static function createPlayer(location:Vector):Entity
	{
		var player:Entity = new Entity();
		player.stateMachine
			.createState("living")
				.ensureComponent(C_AABB, function(e:Entity):Component {
					return new C_AABB(location, new Vector(4, 8));
				})
				.ensureComponent(C_Velocity, function(e:Entity):Component {
					return new C_Velocity(150, 0);
				})
				.ensureComponent(C_Acceleration, function(e:Entity):Component {
					return new C_Acceleration(0, 1000);
				})
				.ensureComponent(C_PlatformerController, function(e:Entity):Component {
					return new C_PlatformerController(150, 275);
				})
				.ensureComponent(C_PlatformerKeyboardControl, function(e:Entity):Component {
					return new C_PlatformerKeyboardControl(Keyboard.A, Keyboard.D, Keyboard.W);
				})
				.ensureComponent(C_Sprite, function(e:Entity):Component {
					return new C_Sprite(5, new Vector(4, 0));
				})
				.ensureComponent(C_Animated, function(e:Entity):Component {
					var animC:C_Animated = new C_Animated();
					
					animC.animations.set('idle', new AnimationDefinition(5, 5, 1, AnimationMode.ONCE));
					animC.animations.set('run', new AnimationDefinition(0, 2, 12, AnimationMode.PINGPONG));
					animC.animations.set('jump', new AnimationDefinition(4, 4, 1, AnimationMode.ONCE));
					animC.animations.set('fall', new AnimationDefinition(6, 6, 1, AnimationMode.ONCE));
					
					animC.currentAnimation = 'idle';
					
					return animC;
				})
				.ensureComponent(C_Collider, function(e:Entity):Component {
					return new C_Collider((1 << 0), (1 << 1));
				})
				.ensureComponent(C_TileSheet, function(e:Entity):Component {
					var characterSheet:C_TileSheet = new C_TileSheet("assets/demos/platformer/graphics/player.png", 16);
					for (y in 0...Std.int(characterSheet.sheetSize.y))
					{
						for (x in 0...Std.int(characterSheet.sheetSize.x))
						{
							//characterSheet.tileSheet.addTileRect(new Rectangle((x * characterSheet.tileSize), (y * characterSheet.tileSize), characterSheet.tileSize, characterSheet.tileSize));
							characterSheet.tileSheet.addTileRect(new Rectangle(Math.fround(x * characterSheet.tileSize), Math.fround(y * characterSheet.tileSize), 16, 16));
						}
					}
					return characterSheet;
				})
				.ensureComponent(C_GroundDetector, function(e:Entity):Component {
					return new C_GroundDetector();
				})
				.ensureComponent(C_DebugDraw, function(e:Entity):Component {
					return new C_DebugDraw();
				});
		
		player.stateMachine.changeState("living");
		return player;
	}
}