package com.blazingmammothgames.woolli;

import haxe.macro.Context;
import haxe.macro.Expr;
import sys.io.Process;

/**
 * ...
 * @author Kenton Hamaluik
 */
class VersionBuilder
{
	macro static public function build():Array<Field>
	{
		// get the version from the git repository
		var version:String = new Process("git", ["describe", "--always", "--tag"]).stdout.readAll().toString();
		
		// remove the commit count and the commit description
		version = version.substr(0, version.lastIndexOf("-"));
		version = version.substr(0, version.lastIndexOf("-"));
		
		var fields = Context.getBuildFields();
		var newField = {
			name: "Version",
			doc: "Version " + version + " from git-tag",
			meta: [],
			access: [AStatic, APublic, AInline],
			kind: FVar(macro:String, macro $v{version}),
			pos: Context.currentPos()
		};
		fields.push(newField);
		return fields;
	}
}