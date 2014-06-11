package hml.base;

import haxe.macro.Type;

using haxe.macro.Context;
using haxe.macro.Tools;

class MacroTools {

	static public function isChildOf(type:Type, baseType:String) {
		var clazz;
		try {
			clazz = type.follow().getClass();
		} catch (e:Dynamic) { return false; }
			
		while (clazz != null) {
			if (clazz != null && clazz.module + "." + clazz.name == baseType) return true;
			clazz = clazz.superClass != null ? clazz.superClass.t.get() : null;
		}
		return  false;
	}

}