package hml.xml;

import haxe.ds.HashMap;
import haxe.macro.Expr.Position;
import haxe.macro.Context;
import hml.base.Strings;
import hml.base.MacroTools;

using Reflect;
using haxe.Json;

class XMLDataRoot extends XMLData {

	public var type:String;
	public var file:String;
	public var pos:Position;

	override function toValue():Dynamic {
		var res = super.toValue();
		Reflect.setField(res, "type", '$type');
		return res;
	}
}

class XMLData {

	static inline var TYPE_DELEMITER = ".";

	public var name:XMLQName = null;

	public var namespaces:Map<String, String> = new Map();

	public var attributes:HashMap<XMLQName, String> = new HashMap();

	public var nodes:Array<XMLData> = [];

	public var parent:XMLData = null;

	public var root:XMLDataRoot;

	public var cData:Null<String> = null;

	public function new() {}

	function toValue():Dynamic {
		return {
				name:name.toString(), 
				namespaces:namespaces,
				attributes:[for (a in attributes.keys()) a.toString() => attributes.get(a)],
				nodes: [for (n in nodes) n.toValue()],
				cData:cData
			};
	}

	public inline function toString():String return toValue().stringify("   ");

	public function resolveNamespace(namespace:Null<String>):Null<String> {
		if (namespace == null) namespace = "*";
		var t = this;
		while (t != null) {
			var ns = t.namespaces[namespace];
			if (ns != null) return ns;
			t = t.parent;
		}
		return null;
	}

	public function resolveType(qName:XMLQName):String {
		var ns = resolveNamespace(qName.ns);
		if (ns == null) return null;
		return ns.length > 0 ? ns + TYPE_DELEMITER + qName.name : qName.name;
	}
}

class Type extends Node {

	public var type:String;

	public var file:String;
	public var pos:Position;
	public var implementsList:Array<TypeString> = null;

	public var rootModel:XMLDataRoot;

	override function toValue():Dynamic {
		var res = super.toValue();
		Reflect.setField(res, "file", '$file');
		Reflect.setField(res, "implementsList", '$implementsList');
		return res;
	}
}

class Node {
	public var name:XMLQName;
	public var superType:String;
	public var generic:Array<TypeString> = null;
	public var nativeType:haxe.macro.Type;
	
	public var id:String;
	public var idSetted = false;

	public var nodes:Array<Node> = [];

	public var children:Array<Node> = [];
	public var unresolvedNodes:Array<Node> = [];

	public var cData:Null<String> = null;

	public var parent:Node;

	public var model:XMLData;

	public var root:Type;

	public var oneInstance = false;

	public var extra:Map<String, Dynamic> = new Map();

	public function new() {}

	function toValue():Dynamic {
		return {
			name: name.toString(),
			superType: superType,
			nativeType: Std.string(nativeType),
			id: id,
			nodes: [for (n in nodes) n.toValue()],
			children: [for (n in children) n.toValue()],
			unresolved: [for (n in unresolvedNodes) n.toValue()],
			cData: cData
		}
	}

	public inline function toString():String return toValue().stringify("   ");
}

class XMLQName {
	public var ns:Null<String>;
	public var name:String;

	static inline var DELIMITER = ":";

	public inline function new(name:String, ?ns:String) {
		this.name = name;
		this.ns = ns;
	}

	static public inline function toXMLQName(str:String):XMLQName {
		var t = str.split(DELIMITER);
		if (t.length > 2) throw 'XMLQName incorrect "$str"';
		else return t.length == 2 ? new XMLQName(t[1], t[0]) : new XMLQName(str);
	}

	public inline function toString():String return '${ns != null ? ns : "*"}$DELIMITER${name}';

	public inline function equals(b:XMLQName):Bool return hashCode() == b.hashCode();

	public inline function hashCode():Int {
		var h:Int = 0;
		var s = toString();
		for (i in 0...s.length){  
			h = (h << 5) - h + StringTools.fastCodeAt(s, i); 
		}
		return h;
	}
}