package com.blazingmammothgames.woolli.core;
import com.blazingmammothgames.woolli.core.Universe;
import com.blazingmammothgames.woolli.core.WoolliException;
import haxe.ds.StringMap;

/**
 * ...
 * @author Kenton Hamaluik
 */
class GameStateMachine
{
	private var universes:StringMap < Void->Universe > = new StringMap < Void->Universe > ();
	public var universe:Universe = null;
	public var currentUniverse(default, null):String = "";
	
	public function new()
	{
		
	}
	
	public function addUniverse(name:String, instantiator:Void->Universe):Void
	{
		// can't have duplicate universes
		if (universes.exists(name))
			throw new WoolliException("Can't create two universes with identical names!", false);
			
		// add it
		universes.set(name, instantiator);
	}
	
	public function switchUniverse(newUniverse:String)
	{
		if (universe != null)
		{
			universe.destroy();
		}

		if(!universes.exists(newUniverse))
			throw new WoolliException("Can't switch to universe '" + newUniverse + "' as it doesn't exist!", false);

		var instantiator:Void->Universe = universes.get(newUniverse);
		universe = instantiator();
		Universe.current = universe;
		currentUniverse = newUniverse;
	}
}