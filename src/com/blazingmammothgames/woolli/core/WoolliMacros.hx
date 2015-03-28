package com.blazingmammothgames.woolli.core;
import haxe.macro.Expr;

/**
 * ...
 * @author Kenton Hamaluik
 */
class WoolliMacros
{
	macro public static function add(e:Expr):Expr
	{
		return macro $e + $e;
	}
}