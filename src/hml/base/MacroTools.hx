package hml.base;

import haxe.macro.Type;
import haxe.macro.Expr;

using haxe.macro.Context;
using haxe.macro.Tools;

using StringTools;

/**
 * Type definition with generic parameters
 */
typedef TypeString = {
	type:String,
	params:Array<TypeString>
}

class TypeStringTools {

	/**
	 * Convert string "Map<String, Array<Int>>" to TypeString struct 
	 * {
	 *    type:Map, 
	 *    params:[
	 *        {
	 *            type:String,
	 *            params:[]
	 *        }, 
	 *        {
	 *            type:Array,
	 *            params:
	 *            	{
	 *            	    type:Int,
	 *            	    params:[]
	 *            	 }
	 *         }
	 *    ]
	 * }
	 * 
	 * @param  str type defenition
	 * @return     array of TypeString structurs
	 */
	static public function stringToTypes(str:String):Array<TypeString> {
		return TypeStringTools.stringToTypesMap(str);
	}

	static function stringToTypesMap(str:String):Array<TypeString> {
		var reg = ~/\s*([\.\w]*)\s*<(([^<>]*|(?R))*)>/g;
		var res = [];
		
		while (reg.match(str)) {
			for (t in reg.matchedLeft().split(",")) {
				if (t.trim().length > 0) res.push({type:t.trim(), params:[]});
			}

			res.push({type:reg.matched(1), params:TypeStringTools.stringToTypesMap(reg.matched(2))});
			
			str = reg.matchedRight();
		}
		if (res.length == 0) {
			var types = str.split(",");
			for (t in types) res.push({type:t.trim(), params:[]});
		}
		return res;
	}

	/**
	 * Convert TypeString to valid haxe code string
	 * {type:String, params:[] } convert to "String"
	 * 
	 * @param  types<TypeString> array of TypeString structurs
	 * @return                   valid haxe type name
	 */
	static public function typesToString(types:Array<TypeString>):String {
		function map(types:Array<TypeString>) {
			return [for (t in types) t.type + (t.params.length == 0 ? "" : '<${map(t.params)}>')].join(", ");
		}
		return map(types);
	}

	/**
	 * Convert TypeString to haxe.macro.Type, resolving generic params
	 *
	 * throws Context.getType errors
	 * 
	 * @param  types<TypeString> array of TypeString structurs
	 * @return                   array of haxe.macro.Type 
	 */
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

class ClassTypeTools {

	/**
	 * resolve inheritance
	 * 
	 * @param  clazz    source ClassType
	 * @param  baseType target ComplexType (class or interface)
	 * @return          source class is subclass of baseType or implements baseType interface
	 */
	static public function isChildOf(clazz:ClassType, baseType:ComplexType):Bool {
		var name = getComplexTypeName(baseType);
		if (name == null) throw 'unknown type name for ${clazz.module}';
			
		while (clazz != null) {
			if (clazz != null && typeName(clazz) == name) return true;
			for (i in clazz.interfaces) {
				if (i.t != null && typeName(i.t.get()) == name) return true;
			}
			clazz = clazz.superClass != null ? clazz.superClass.t.get() : null;
		}
		return false;
	}

	/**
	 * generate type name using package and type name
	 * typeName({pack:["flash", "display", "Sprite"], name:"Sprite"}) return flash.display.Sprite.Sprite
	 * 
	 * @param  type struct {pack:Array<String>, name:String}
	 * @return type name string
	 */
	@:extern public static inline function typeName(type:{pack:Array<String>, name:String}):String 
		return type.pack.length > 0 ? type.pack.join(".") + ":" + type.name : type.name;

	/**
	 * generate type name of ComplexType. Use typeName method
	 * @param  baseType ComplexType
	 *
	 * @see typeName
	 * 
	 * @return          type name string
	 */
	static public function getComplexTypeName(baseType:ComplexType) {
		return switch (baseType) {
			case TPath(p): typeName(p);
			case TParent(ct) | TOptional(ct): getComplexTypeName(ct);
			case _: null;
		}
	}
}

class TypeTools {

	/**
	 * resolve inheritance
	 *
	 * @see ClassTypeTools.isChildOf
	 * 
	 * @param  type     source type haxe.macro.Type
	 * @param  baseType target type or interface
	 * @return          source type is subclass of target type or implements target interface 
	 */
	static public function isChildOf(type:haxe.macro.Type, baseType:ComplexType) {
		var clazz;
		try { clazz = type.follow().getClass(); } catch (e:Dynamic) { return false; }

		return ClassTypeTools.isChildOf(clazz, baseType);
	}
}