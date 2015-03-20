package com.blazingmammothgames.woolli;

//import com.blazingmammothgames.woolli.core.IGame;
import haxe.Timer;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.media.Sound;
import openfl.Assets;
import openfl.media.SoundChannel;

/**
 * ...
 * @author Kenton Hamaluik
 */
class Splash
{
	private var main:Sprite;
	//private var game:IGame;
	
	private var roar:Sound;
	private var channel:SoundChannel;
	
	private var logo:Bitmap;
	private var container:Sprite;
	
	var shakeAmplitude:Float = 10;
	private var shaking:Bool = true;
	private var startTime:Float = 0;

	public function new(main:Sprite/*, game:IGame*/) 
	{
		this.main = main;
		//this.game = game;
		
		#if disableSplash
			//game.onInit(main);
			//main.addEventListener(Event.ENTER_FRAME, game.onFrame);
		#else
			// init here
			#if flash
				roar = Assets.getSound("assets/sounds/blazingmammothgames.mp3");
			#else
				roar = Assets.getSound("assets/sounds/blazingmammothgames.ogg");
			#end
			
			// play the sound
			channel = roar.play(0);
			channel.addEventListener(Event.SOUND_COMPLETE, roarComplete);
			
			// show the logo
			main.stage.color = 0xffffff;
			container = new Sprite();
			logo = new Bitmap(Assets.getBitmapData("assets/img/logo_4x.png"));
			container.addChild(logo);
			logo.x = (main.stage.stageWidth - logo.width) / 2;
			logo.y = (main.stage.stageHeight - logo.height) / 2;
			main.addChild(container);
			
			main.addEventListener(Event.ENTER_FRAME, onFrame);
			startTime = Timer.stamp();
		#end
	}
	
	private function roarComplete(event:Event):Void
	{
		channel.removeEventListener(Event.SOUND_COMPLETE, roarComplete);
		channel.stop();
		shaking = false;
		startTime = Timer.stamp();
		container.x = 0;
		container.y = 0;
	}
	
	private function onFrame(event:Event):Void
	{
		if (shaking)
		{
			var t:Float = Timer.stamp() - startTime;
			var a:Float = -0.1490 * Math.pow(t, 4) + 1.2605 * Math.pow(t, 3) - 3.6256 * Math.pow(t, 2) + 3.6298 * t - 0.1685;
			container.x = (Math.random() * 2 - 1) * shakeAmplitude * a;
			container.y = (Math.random() * 2 - 1) * shakeAmplitude * a;
		}
		else
		{
			// cooldown period
			if (Timer.stamp() - startTime >= 3)
			{
				main.removeEventListener(Event.ENTER_FRAME, onFrame);
				main.removeChild(container);
				//game.onInit(main);
				//main.addEventListener(Event.ENTER_FRAME, game.onFrame);
			}
		}
	}
	
	public function floatAdd(a:Float, b:Float):Float
	{
		return a + b;
	}
}