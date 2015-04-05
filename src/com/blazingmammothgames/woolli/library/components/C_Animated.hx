package com.blazingmammothgames.woolli.library.components;

import com.blazingmammothgames.woolli.core.Component;
import haxe.ds.StringMap;

/**
 * ...
 * @author Kenton Hamaluik
 */

enum AnimationMode {
	LOOP;
	ONCE;
	PINGPONG;
}

enum AnimationState {
	PLAYING;
	PAUSED;
}

class AnimationDefinition {
	public var startFrame:Int;
	public var endFrame:Int;
	public var framePeriod:Float;
	public var mode:AnimationMode;
	
	public function new(startFrame:Int, endFrame:Int, frameRate:Float, mode:AnimationMode)
	{
		this.startFrame = startFrame;
		this.endFrame = endFrame;
		this.framePeriod = 1 / frameRate;
		this.mode = mode;
	}
}
class C_Animated extends Component
{
	public var state:AnimationState;
	public var currentFrame:Int;
	public var frameDirection:Int;
	public var lastFrameTime:Float;
	public var currentAnimation:String = "";
	public var animations:StringMap<AnimationDefinition> = new StringMap<AnimationDefinition>();

	public function new() 
	{
		super();
		state = AnimationState.PAUSED;
		currentFrame = 0;
		frameDirection = 1;
		lastFrameTime = 0;
		currentAnimation = "";
	}
	
}