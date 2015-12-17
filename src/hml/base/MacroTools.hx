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
		var name = ComplexTypeTools.getComplexTypeName(baseType);
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
	 * typeName({pack:["flash", "display", "Sprite"], name:"Sprite"}) return flash.display.Sprite
	 *
	 * @param  type struct {pack:Array<String>, name:String}
	 * @return type name string
	 */
	@:extern public static inline function typeName(type:{pack:Array<String>, name:String}):String {
        return if (type.pack[type.pack.length - 1] == type.name) type.pack.join(".");
            else if (type.pack.length > 0) type.pack.join(".") + "." + type.name;
            else type.name;
	}
}

class ComplexTypeTools {
	/**
	 * generate type name of ComplexType. Use typeName method
	 * @param  baseType ComplexType
	 *
	 * @see typeName
	 *
	 * @return          type name string
	 */
	static public function getComplexTypeName(baseType:ComplexType):String {
		return switch (baseType) {
			case TPath(p): ClassTypeTools.typeName(p);
			case TParent(ct) | TOptional(ct): getComplexTypeName(ct);
			case _: null;
		}
	}

	static public function resolve(ct:ComplexType):ComplexType {
		return TypeTools.resolve(ct.toType()).toComplexType();
	}

	static public function resolveToType(ct:ComplexType):Type {
		return TypeTools.resolve(ct.toType());
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
		var name = ComplexTypeTools.getComplexTypeName(baseType);
		if (name == null) throw 'unknown type name for ${baseType}';
		type = type.follow();

		inline function check(type:haxe.macro.Type) {
			var fullPath = getFullPath(type);
			return fullPath != null && fullPath.join(".") == name;
		}

		inline function checkTypes(types:Array<{t:haxe.macro.Type, field:Null<ClassField>}>) {
			var canCast = false;
			for (t in types) if (isChildOf(t.t, baseType)) {
				canCast = true;
				break;
			}
			return canCast;
		}

		return switch type {
			case TInst(ref, _): ClassTypeTools.isChildOf(ref.get(), baseType);
			case TAbstract(_, _) if (check(type)): true;
			case TAbstract(_.get() => type, _): checkTypes(type.to) && checkTypes(type.from);
			case _: check(type);
		}
	}

	static public inline function getFullPath(type:haxe.macro.Type):Array<String> {
		return if (type == null) null;
		else switch type {
				case TMono(tp): getFullPath(tp.get());
				case TEnum(tp, _): BaseTypeTools.baseTypePath(tp.get());
				case TInst(tp, _): BaseTypeTools.baseTypePath(tp.get());
				case TType(tp, _): BaseTypeTools.baseTypePath(tp.get());
				case TFun(_, _): null;
				case TAnonymous(_): null;
				case TDynamic(_): null;
				case TLazy(f): getFullPath(f());
				case TAbstract(tp, _): BaseTypeTools.baseTypePath(tp.get());
			}
	}

	static public function resolve(t:Type):Type {
		return t.follow();
	}
}

class BaseTypeTools {

	static public inline function baseTypePath(t:BaseType):Array<String> {
		return if (t == null)
			null;
		else
			t.pack.length > 0 ? t.pack.concat([t.name]) : [t.name];
	}
}


class AbstractTypeTools {

	static public function findField (c:AbstractType, name:String):Null<ClassField> {
		//check own abstract fields
		for (field in c.impl.get().statics.get()) {
			if (field.name == name) {
				return field;
			}
		}

		//check for forwarded fields
		for (meta in c.meta.extract(':forward')) {
			var forwarded = (meta.params == null || meta.params.length == 0);
			if (!forwarded) {
				for (expr in meta.params) {
					switch (expr.expr) {
						case EConst(CIdent(fieldName)):
							if (fieldName == name) {
								forwarded = true;
								break;
							}
						case _:
					}
				}
			}

			if (forwarded) {
				return switch (c.type) {
					case TAbstract(ref,_) : findField(ref.get(), name);
					case _                : c.type.getClass().findField(name, false);
				}
			}
		}
// Context.error('', Context.currentPos());
		return null;
	}
}