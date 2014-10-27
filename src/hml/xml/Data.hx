package hml.xml;

import haxe.ds.HashMap;
import haxe.macro.Expr.Position;
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
		Reflect.setField(res, "file", '$file');
		return res;
	}
}

typedef XMLDataPosLine = {line:Int, pos:Int}

typedef XMLDataPos = {from:XMLDataPosLine, to:XMLDataPosLine, file:String, min:Int, max:Int}

class XMLData {

	static inline var TYPE_DELEMITER = ".";

	public var name:XMLQName = null;

	public var nodePos:XMLDataPos;

	public var namespaces:Map<String, String> = new Map();

	public var attributes:HashMap<XMLQName, String> = new HashMap();

	public var attributesPos:HashMap<XMLQName, XMLDataPos> = new HashMap();

	public var nodes:Array<XMLData> = [];

	public var parent:XMLData = null;

	public var root:XMLDataRoot;

	public var cData:Null<String> = null;

	public function new() {}

	function toValue():Dynamic {
		return {
				name:name.toString(),
				nodePos: nodePos,
				namespaces:namespaces,
				attributes:[for (a in attributes.keys()) a.toString() => attributes.get(a)],
				attributesPos:[for (a in attributesPos.keys()) a.toString() => attributesPos.get(a)],
				nodes: [for (n in nodes) n.toValue()],
				cData:cData
			};
	}

	public inline function toString():String {
		return toValue().stringify("   ");
	}

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
    public var declarations:Array<Node> = [];

	public var rootModel:XMLDataRoot;

	override function toValue():Dynamic {
		var res = super.toValue();
		Reflect.setField(res, "file", '$file');
		Reflect.setField(res, "implementsList", '$implementsList');
		Reflect.setField(res, "declarations", '$declarations');
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

    public var meta:Null<String> = null;

    public var publicAccess = true;

	public function new() {}

	function toValue():Dynamic {
		return {
			name: name.toString(),
			superType: superType,
			nativeType: Std.string(nativeType),
			id: id,
            publicAccess: publicAccess,
			nodes: [for (n in nodes) n.toValue()],
			children: [for (n in children) n.toValue()],
			unresolved: [for (n in unresolvedNodes) n.toValue()],
            meta: meta,
			cData: cData
		}
	}

	public inline function toString():String {
		return toValue().stringify("   ");
	}
}

class XMLQName {
	public var ns:Null<String>;
	public var name:String;

	static inline var DELIMITER = ":";

	public inline function new(name:String, ?ns:String) {
		this.name = name;
		this.ns = ns;
	}

	static public function toXMLQName(str:String):XMLQName {
		if (str == null || str.length <= 0) throw 'XMLQName is empty "$str"';
		var t = str.split(DELIMITER);
		if (t.length > 2) throw 'XMLQName incorrect "$str"';
		else return if (t.length == 2) {
			var name = t[1];
			var ns = t[0];
			if (name.length <= 0)
				throw 'XMLQName incorrect "$str". Name is empty';
			if (ns.length <= 0)
				throw 'XMLQName incorrect "$str". Namespace is empty';

			new XMLQName(name, ns);
		} else {
			new XMLQName(str);
		}
	}

	public inline function toString():String {
		return '${ns != null ? ns : "*"}$DELIMITER${name}';
	}

	public inline function equals(b:XMLQName):Bool {
		return hashCode() == b.hashCode();
	}

	public inline function hashCode():Int {
		var h:Int = 0;
		var s = toString();
		for (i in 0...s.length) {
			h = (h << 5) - h + StringTools.fastCodeAt(s, i);
		}
		return h;
	}
}