package com.blazingmammothgames.woolli.util;
import haxe.Log;
import haxe.PosInfos;
import openfl.Lib;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * ...
 * @author Kenton Hamaluik
 */
class CustomTrace
{
	private static var overlayText:TextField;
	public static function enableCustomTrace(?font:String):Void
	{
		if (overlayText == null)
		{
			overlayText = new TextField();
			overlayText.width = Lib.current.stage.stageWidth;
			overlayText.height = Lib.current.stage.stageHeight;
			overlayText.mouseEnabled = false;
			overlayText.wordWrap = true;
			overlayText.defaultTextFormat = new TextFormat(font, 12, 0xffffff);
			overlayText.embedFonts = font != null;
			Lib.current.stage.addChild(overlayText);
			
			Log.trace = customTrace;
		}
	}
	
	public static function clear():Void
	{
		overlayText.text = "";
	}
	
	private static function customTrace(value:Dynamic, ?infos:PosInfos):Void
	{
		if (overlayText == null)
			enableCustomTrace();
			
		overlayText.appendText(formatOutput(value, infos) + "\n");
		
		if (overlayText.maxScrollV > 1)
		{
			var text:String = overlayText.text;
			var cutoff:Int = text.indexOf(#if flash "\r" #else "\n" #end) + 1;
			overlayText.text = text.substr(cutoff);
		}
		
		overlayText.scrollV = overlayText.maxScrollV;
	}
	
	private static function formatOutput(value:Dynamic, infos:PosInfos):String
	{
		return (infos == null ? "" : infos.fileName + ":" + infos.lineNumber + ": ") + Std.string(value);
	}
}