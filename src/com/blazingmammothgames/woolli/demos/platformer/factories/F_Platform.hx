package com.blazingmammothgames.woolli.demos.platformer.factories;

import com.blazingmammothgames.woolli.core.Component;
import com.blazingmammothgames.woolli.core.Entity;
import com.blazingmammothgames.woolli.library.components.C_AABB;
import com.blazingmammothgames.woolli.library.components.C_Collider;
import com.blazingmammothgames.woolli.util.Vector;

/**
 * ...
 * @author Kenton Hamaluik
 */
class F_Platform
{
	public static function createPlatform(x:Float, y:Float, w:Float, h:Float):Entity
	{
		var platform:Entity = new Entity();
		platform.addComponent(new C_AABB(new Vector(x + (w / 2), y + (h / 2)), new Vector(w / 2, h / 2)));
		platform.addComponent(new C_Collider((1 << 1), (1 << 0)));
		return platform;
	}
}