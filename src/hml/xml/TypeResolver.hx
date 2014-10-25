package hml.xml;

import haxe.macro.Context;
import hml.base.BaseFileProcessor;
import hml.xml.Data;
import hml.xml.XMLProcessor;
import hml.base.MatchLevel;
import hml.base.MacroTools;

using haxe.macro.Tools;
using hml.base.MatchLevel;
using Lambda;
using Reflect;
using StringTools;
using hml.base.MacroTools;

class DefaultXMLDataParser implements IXMLDataNodeParser<XMLData, Node, Node> {

	static public inline var HAXE_NAMESPACE = "http://haxe.org/";

	public function new() {}

	public function match(data:XMLData, parent:Node):MatchLevel {
		return GlobalLevel;
	}

	function isID(qName:XMLQName):Bool {
		return qName.ns == null && qName.name == "id";
	}

	public function parse(data:XMLData, parent:Node, parser:IXMLDataParser<XMLData, Node>):Node {
		var node = new Node();
		node.root = parent.root;
		node.parent = parent;
		parseNode(node, data, parser);
		return node;
	}

	function parseNode(node:Node, data:XMLData, parser:IXMLDataParser<XMLData, Node>) {
		node.superType = data.resolveType(data.name);
		if (node.superType == null)
			Context.error('can\'t resolve namespace', Context.makePosition(data.nodePos));

		node.model = data;
		node.name = data.name;
		node.cData = data.cData;
		
		parseAttributes(node, data, parser);
		parseNodes(node, data, parser);
	}

	function processSpecificNamespace(name:XMLQName, node:Node, ?child:Node, ?cData:String, pos:XMLDataPos):Bool {
		inline function data() return child != null ? child.cData : cData;
		var res = false;
		switch (node.model.resolveNamespace(name.ns)) {
			case HAXE_NAMESPACE:
				switch (name.name) {
					case "generic": 
						node.generic = data().stringToTypes();
						res = true;
                    case "Declarations" if (Std.is(node, Type)):
                        var type:Type = cast node;
                        for (c in child.unresolvedNodes) type.declarations.push(c);
                        res = true;
					case _:
						Context.error('unknown specific haxe attribute "${name}"', Context.makePosition(pos));
				}
			case _:
		}
		return res;
	}

	function parseAttributes(node:Node, data:XMLData, parser:IXMLDataParser<XMLData, Node>) {
		for (a in data.attributes.keys()) {
			if (processSpecificNamespace(a, node, data.attributes.get(a), data.attributesPos.get(a))) continue;
			if (isID(a)) {
				node.id = data.attributes.get(a);
				node.idSetted = true;
				if (!~/^[^\d\W]\w*$/.match(node.id))
					Context.error('invalid id "${node.id}"', Context.makePosition(node.model.nodePos));
			} else {
				var n:Node = new Node();
				n.name = new XMLQName(a.name, node.name.ns);
				n.root = node.root;
				n.parent = node;
				n.superType = data.resolveType(n.name);
				n.cData = data.attributes.get(a);

				n.model = new XMLData();
				n.model.nodePos = data.attributesPos.get(a);
				n.model.name = n.name;
				n.model.cData = n.cData;
				
				node.unresolvedNodes.push(n);
			}
		}
	}

	function parseNodes(node:Node, data:XMLData, parser:IXMLDataParser<XMLData, Node>) {
		for (n in data.nodes) {
			var child = parser.parse(n, node);
			if (!processSpecificNamespace(child.name, node, child, child.model.nodePos)) node.unresolvedNodes.push(child);
		}
	}
}

class DefaultXMLDataRootParser extends DefaultXMLDataParser implements IXMLDataNodeParser<XMLData, Node, Type> {

	override public function match(data:XMLData, parent:Node):MatchLevel {
		return Std.is(data, XMLDataRoot) ? ClassLevel : None;
	}

	override function processSpecificNamespace(name:XMLQName, node:Node, ?child:Node, ?cData:String, pos:XMLDataPos):Bool {
		inline function data() return child != null ? child.cData : cData;
		
		var res = false;
		switch (node.model.resolveNamespace(name.ns)) {
			case DefaultXMLDataParser.HAXE_NAMESPACE:
				switch (name.name) {
					case "implements":
						cast(node, Type).implementsList = data().stringToTypes();
						res = true;
					case _:
				}
			case _:
		}
	
		return res ? res : super.processSpecificNamespace(name, node, child, cData, pos);
	}

	override public function parse(data:XMLData, parent:Node, parser:IXMLDataParser<XMLData, Node>):Type {
		var root:XMLDataRoot = cast data;

		var type = new Type();
		type.root = type;
		type.file = root.file;
		type.pos = root.pos;
		type.type = root.type;
		type.parent = null;

		parseNode(type, root, parser);

		type.id = "this";
		type.idSetted = true;

		return type;
	}
}

class DefaultHaxeTypeResolver implements IHaxeTypeResolver<Node, Type> {
	
	public var types:Map<String, Type>;
	
	public function new() {}

	public function getNativeType(node:Node):haxe.macro.Type {
		var superType = node.superType;
		while (types.exists(superType)) {
			node = types.get(superType);
			superType = node.superType;
		}
		
		var type;
		try {
			type = Context.getType(superType);
		} catch (e:Dynamic) {}
		if (node.generic != null) {
			switch (type) {
				case TAbstract(_, params) | TInst(_, params) | TEnum(_, params) | TType(_, params):
					var types = null;
					try {
						types = node.generic.toTypeArray();
					} catch (e:Dynamic) {}
					if (types != null) {
						while (params.length > 0) params.pop();
						for (s in types) params.push(s);
						node.generic = null;
					}
				case _:
			}
		}
		return type;
	}

	public function isType(node:Node):Bool {
		if (types.exists(node.superType)) return true;
		return try {
			Context.getType(node.superType) != null;
		} catch (e:Dynamic) { false; }
	}

	public function hasField(node:Node, qName:XMLQName):Bool {
		if (node.name.ns != qName.ns) return false;
		var type;
		if ((type = types[node.superType]) != null) {
			for (n in type.children) if (qName.name == n.id) return true;
			for (n in type.nodes) if (qName.name == n.id) return true;
			return hasField(type, new XMLQName(qName.name, type.name.ns));
		}
		return try {
			Context.getType(node.superType).getClass().findField(qName.name, false) != null;
		} catch (e:Dynamic) { false; }
	}

	public function getFieldNativeType(node:Node, qName:XMLQName):haxe.macro.Type {
		var type;
		if ((type = types[node.superType]) != null) {
			for (n in type.children) if (qName.name == n.id) return n.nativeType;
			for (n in type.nodes) if (qName.name == n.id) return n.nativeType;
			return getFieldNativeType(type, qName);
		}
		return try {
			Context.getType(node.superType).getClass().findField(qName.name, false).type;
		} catch (e:Dynamic) { null; }
	}
}

class TypeResolver implements ITypeResolver<XMLDataRoot, Type> implements IXMLDataParser<XMLData, Node> {

	var parsers:Array<IXMLDataNodeParser<XMLData, Node, Dynamic>>;
	var resolvers:Array<IHaxeTypeResolver<Node, Type>>;
	var types:Map<String, Type>;

	public function new(parsers:Array<IXMLDataNodeParser<XMLData, Node, Node>>, resolvers:Array<IHaxeTypeResolver<Node, Type>>) {
		this.parsers = parsers;
		this.resolvers = resolvers;
	}

	public function parse(data:XMLData, parent:Node):Node {
		var parser;
		try {
			parser = parsers.findMatch(function (p) return p.match(data, parent));
		} catch (e:Dynamic) {
			Context.error(e, Context.currentPos());
		}
		return parser.parse(data, parent, this);
	}

	public function resolve(data:Array<XMLDataRoot>):Array<Type> {
		types = new Map();
		for (r in resolvers) r.types = types;

		for (i in data) {
			var type:Type = cast parse(i, null);
			type.nativeType = getNativeType(type);
			types[type.type] = type;
		}

		if (!(resolveTypes(resolveNode) && resolveTypes(recursiveResolve)))
			types.iter(throwResolveError);

		if (!resolveTypes(postResolve))
			Context.error('can\'t resolve node native types. Please send error report to deep (system.grand<at>gmail.com).', Context.currentPos());

		return [for (t in types) t];
	}

	function resolveTypes(resolveMethod:Node->Bool, n = 10):Bool {
		var i = 0;
		var flag = false;
		while (!flag && i++ < n) {
			flag = true;
			for (t in types) flag = flag && resolveMethod(t);
		}
		#if hml_debug
		trace("iterations: " + i);
		#end
		return flag;
	}

	function throwResolveError(t:Node) {
		for (n in t.unresolvedNodes)
			Context.error('can\'t resolve node "${n.name}". Can\'t find haxe type or field with same name.', Context.makePosition(n.model.nodePos));
		t.children.iter(throwResolveError);
		t.nodes.iter(throwResolveError);
	}

	function resolveNode(t:Node):Bool {
		inline function removeItem(pos:UInt) t.unresolvedNodes.splice(pos, 1);
		if (t.unresolvedNodes.length > 0) {
			var i = 0;
			while (i < t.unresolvedNodes.length) {
				var n = t.unresolvedNodes[i];
				if (n.nativeType == null) n.nativeType = getNativeType(n);
				if (hasField(t, n.name)) {
					removeItem(i);
					n.nativeType = getFieldNativeType(t, n.name);
					t.nodes.push(n);
				} else if (isType(n)) {
					removeItem(i);
					t.children.push(n);
				} else {
					i++;
				}
			}
		}
		return t.unresolvedNodes.length == 0;
	}

	function recursiveResolve(n:Node):Bool {
		if (resolveNode(n)) {
			var res = true;
			inline function iterNodes(nodes:Array<Node>)
				for (c in nodes) res = res && recursiveResolve(c);

			iterNodes(n.children);
			iterNodes(n.nodes);
            if (Std.is(n, Type)) iterNodes(cast(n, Type).declarations);
			return res;
		}
		return false;
	}

	function postResolve(n:Node):Bool {
		if (n.nativeType == null) n.nativeType = getNativeType(n);
		if (n.nativeType == null) return false;
		var res = true;

		inline function processNode(node:Node) res = res && postResolve(node);
		inline function iterNodes(nodes:Array<Node>) for (c in nodes) processNode(c);

		n.oneInstance = n.id == null;
		
		iterNodes(n.children);
        if (Std.is(n, Type)) iterNodes(cast(n, Type).declarations);
		for (c in n.nodes) {
			processNode(c);
			c.superType = null; // node's supertype is incorrect
		}
		return res;
	}

	function getNativeType(node:Node):haxe.macro.Type {
		for (r in resolvers) {
			var res = r.getNativeType(node);
			if (res != null) return res;
		}
		return null;
	}

	function isType(node:Node):Bool {
		for (r in resolvers) {
			var res = r.isType(node);
			if (res) return true;
		}
		return false;
	}

	function hasField(node:Node, qName:XMLQName):Bool {
		for (r in resolvers) {
			var res = r.hasField(node, qName);
			if (res) return true;
		}
		return false;
	}

	function getFieldNativeType(node:Node, qName:XMLQName):haxe.macro.Type {
		for (r in resolvers) {
			var res = r.getFieldNativeType(node, qName);
			if (res != null) return res;
		}
		return null;
	}
}