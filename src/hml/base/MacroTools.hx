package hml.base;

import haxe.macro.Type;
import haxe.macro.Expr;

using haxe.macro.Context;
using haxe.macro.Tools;

using StringTools;

class MacroTools {

	static public function parseTypeString(str:String):Array<haxe.macro.Type> {
		function map(str):Array<haxe.macro.Type> {
			var reg = ~/\s*(\w*)\s*<(([^<>]*|(?R))*)>/g;
			var res = [];
			
			while (reg.match(str)) {
				for (t in reg.matchedLeft().split(",")) 
					if (t.trim().length > 0) res.push(Context.getType(t.trim()));

				var type = Context.getType(reg.matched(1));
				switch (type) {
					case TAbstract(_, params) | TInst(_, params) | TEnum(_, params) | TType(_, params):
						while (params.length > 0) params.pop();
						for (s in map(reg.matched(2))) params.push(s);
					case _:
				}
				res.push(type);
				
				str = reg.matchedRight();
			}
			if (res.length == 0) {
				var types = str.split(",");
				for (t in types) res.push(Context.getType(t.trim()));
			}
			return res;
		}
		return map(str);
	}

	static public function isChildOf(type:Type, baseType:ComplexType) {
		var name = getComplexTypeName(baseType);
		if (name == null) {
			throw 'unknown type name for ${baseType}';
		}
		var clazz;
		try { clazz = type.follow().getClass(); } catch (e:Dynamic) { return false; }
			
		while (clazz != null) {
			if (clazz != null && typeName(clazz) == name) return true;
			clazz = clazz.superClass != null ? clazz.superClass.t.get() : null;
		}
		return  false;
	}

	@:expose static inline function typeName(type:{pack:Array<String>, name:String}):String 
		return (type.pack != null ? type.pack.join(".") + ":" : "") + type.name;

	static function getComplexTypeName(baseType:ComplexType) {
		return switch (baseType) {
			case TPath(p): typeName(p);
			case TParent(ct) | TOptional(ct): getComplexTypeName(ct);
			case _: null;
		}
	}

}