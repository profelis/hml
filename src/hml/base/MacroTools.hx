package hml.base;

import haxe.macro.Type;
import haxe.macro.Expr;

using haxe.macro.Context;
using haxe.macro.Tools;

using StringTools;

typedef TypeString = {
	type:String,
	params:Array<TypeString>
}

class TypeStringTools {
	static public function stringToTypes(str:String):Array<TypeString> {
		function map(str):Array<TypeString> {
			var reg = ~/\s*([\.\w]*)\s*<(([^<>]*|(?R))*)>/g;
			var res = [];
			
			while (reg.match(str)) {
				for (t in reg.matchedLeft().split(",")) 
					if (t.trim().length > 0) res.push({type:t.trim(), params:[]});

				res.push({type:reg.matched(1), params:map(reg.matched(2))});
				
				str = reg.matchedRight();
			}
			if (res.length == 0) {
				var types = str.split(",");
				for (t in types) res.push({type:t.trim(), params:[]});
			}
			return res;
		}
		return map(str);
	}

	static public function typesToString(types:Array<TypeString>):String {
		function map(types:Array<TypeString>) {
			return [for (t in types) t.type + (t.params.length == 0 ? "" : '<${map(t.params)}>')].join(", ");
		}
		return map(types);
	}

	static public function toTypeArray(types:Array<TypeString>):Array<haxe.macro.Type> {
		function map(data:Array<TypeString>):Array<haxe.macro.Type> {
			var res = [];

			for (t in data) {
				var type = Context.getType(t.type);
				if (t.params.length > 0) {
					switch (type) {
						case TAbstract(_, params) | TInst(_, params) | TEnum(_, params) | TType(_, params):
							while (params.length > 0) params.pop();
							for (s in map(t.params)) params.push(s);
						case _:
					}
				}
				res.push(type);
			}
			return res;
		}
		return map(types);
	}
}

class MacroTools {

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

	@:extern static inline function typeName(type:{pack:Array<String>, name:String}):String 
		return (type.pack != null ? type.pack.join(".") + ":" : "") + type.name;

	static function getComplexTypeName(baseType:ComplexType) {
		return switch (baseType) {
			case TPath(p): typeName(p);
			case TParent(ct) | TOptional(ct): getComplexTypeName(ct);
			case _: null;
		}
	}

}