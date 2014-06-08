package hml.xml;

import haxe.macro.Context;
import hml.base.BaseFileProcessor;
import hml.xml.Data;
import hml.xml.XMLProcessor;
import hml.base.MatchLevel;

using haxe.macro.Tools;
using hml.base.MatchLevel;
using Lambda;
using Reflect;

class DefaultXMLDataParser implements IXMLDataNodeParser<XMLData, Node, Node> {
	public function new() {}

	public function match(data:XMLData, parent:Node):MatchLevel return GlobalLevel;

	function isID(qName:XMLQName) return qName.ns == null && qName.name == "id";

	public function parse(data:XMLData, parent:Node, parser:IXMLDataParser<XMLData, Node>):Node {
		var node = new Node();
		node.root = parent.root;
		node.parent = parent;
		node.model = data;
		node.name = data.name;
		node.superType = data.resolveType(data.name);
		if (node.superType == null) {
			Context.fatalError('can\'t resolve namespace for node ${data.name}', data.root.pos);
		}
		node.cData = data.cData;
		
		parseAttributes(node, data, parent, parser);
		parseNodes(node, data, parent, parser);
		
		return node;
	}

	function parseAttributes(node:Node, data:XMLData, parent:Node, parser:IXMLDataParser<XMLData, Node>) {
		for (a in data.attributes.keys()) {
			if (node.model.resolveNamespace(a.ns) == "http://haxe.org/") {
				switch (a.name) {
					case "generic": node.generic = data.attributes.get(a);
				}
			}
			else if (isID(a)) {
				node.id = data.attributes.get(a);
				if (!~/^[^\d\W]\w*$/.match(node.id))
					Context.error('id error "${node.id}" in file "${node.root.file}"', node.root.pos);
			} else node.attributes.set(a, data.attributes.get(a));
		}
	}

	function parseNodes(node:Node, data:XMLData, parent:Node, parser:IXMLDataParser<XMLData, Node>) {
		for (n in data.nodes) node.unresolvedNodes.push(parser.parse(n, parent));
	}
}

class DefaultHaxeTypeResolver implements IHaxeTypeResolver<Node, Type> {
	public function new() {}

	public var types:Map<String, Type>;

	public function getNativeType(node:Node):haxe.macro.Type {
		var type = node.superType;
		while (types.exists(type)) {
			node = types.get(type);
			type = node.superType;
		}
		return try {
			var type = Context.getType(node.superType);
			if (node.generic != null) {
				switch (type) {
					case TInst(_, params):
						// TODO: support complex generic params
						params.pop();
						params.push(Context.getType(node.generic));
					case _:
				}
			}
			type;
		} catch (e:Dynamic) { null; }
	}

	public function isType(node:Node):Bool {
		if (types.exists(node.superType)) return true;
		return try {
			Context.getType(node.superType) != null;
		} catch (e:Dynamic) { false; }
	}

	public function hasField(node:Node, qName:XMLQName):Bool {
		var type;
		if (node.name.ns != qName.ns) return false;
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
			for (n in type.children) if (qName.name == n.id) return null;
			for (n in type.nodes) if (qName.name == n.id) return null;
			return getFieldNativeType(type, qName);
		}
		return try {
			Context.getType(node.superType).getClass().findField(qName.name, false).type;
		} catch (e:Dynamic) { null; }	
	}
}

class TypeResolver implements ITypeResolver<XMLDataRoot, Type> implements IXMLDataParser<XMLData, Node> {

	public function new(parsers:Array<IXMLDataNodeParser<XMLData, Node, Dynamic>>, resolvers:Array<IHaxeTypeResolver<Node, Type>>) {
		this.parsers = parsers;
		this.resolvers = resolvers;
	}

	var parsers:Array<IXMLDataNodeParser<XMLData, Node, Dynamic>>;
	var resolvers:Array<IHaxeTypeResolver<Node, Type>>;
	var types:Map<String, Type>;

	public function parse(data:XMLData, parent:Node):Node {
		var parser = parsers.findMatch(function (p) return p.match(data, parent));
		return parser.parse(data, parent, this);
	}

	function parseXMLDataRoots(data:Array<XMLDataRoot>):Void {
		for (i in data) {
			var type:Type = new Type();
			type.file = i.file;
			type.pos = i.pos;
			type.type = i.type;
			type.root = type;
			type.id = "this";
			var node = parse(i, type);
			for (n in node.fields()) type.setField(n, node.field(n));

			types[type.type] = type;
		}
	}

	public function resolve(data:Array<XMLDataRoot>):Array<Type> {
		types = new Map();
		for (r in resolvers) r.types = types;

		parseXMLDataRoots(data);

		if (!(resolveTypes(resolveNode) && resolveTypes(recursiveResolve)))
			types.iter(throwResolveError);

		types.iter(postResolve);

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
			Context.error('can\'t resolve node "${n.name}" in file "${t.root.file}"', t.root.pos);
		t.children.iter(throwResolveError);
		t.nodes.iter(throwResolveError);
	}

	function resolveNode(t:Node):Bool {
		inline function removeItem(pos:UInt) t.unresolvedNodes.splice(pos, 1);
		if (t.unresolvedNodes.length > 0) {
			var i = 0;
			while (i < t.unresolvedNodes.length) {
				var n = t.unresolvedNodes[i];
				if (hasField(t, n.name)) {
					removeItem(i);
					n.nativeType = getFieldNativeType(t, n.name);
					t.nodes.push(n);
				} else if (isType(n)) {
					removeItem(i);
					t.children.push(n);
				} else i++;
			}
		}
		return t.unresolvedNodes.length == 0;
	}

	function recursiveResolve(n:Node):Bool {
		if (resolveNode(n)) {
			if (!n.attributesChecked) {
				for (a in n.attributes.keys())
					if (!hasField(n, new XMLQName(a.name, n.name.ns)))
						Context.error('can\'t resolve attribute "${a.name}" in file "${n.root.file}"', n.root.pos);
				n.attributesChecked = true;
			}
			var res = true;
			inline function iterNode(c) res = res && recursiveResolve(c);
			for (c in n.children) iterNode(c);
			for (c in n.nodes) iterNode(c);
			return res;
		}
		return false;
	}

	var nodeIds:Map<Node, Int> = new Map();

	function postResolve(n:Node):Bool {
		if (n.id == null) {
			var i:Int = nodeIds.exists(n.root) ? nodeIds.get(n.root) : 0;
			n.id = "field" + (i++);
			nodeIds[n.root] = i;
		}
		if (n.nativeType == null) n.nativeType = getNativeType(n);
		for (c in n.children) {
			if (c.id == null) c.oneInstance = true;
			postResolve(c);
		}
		var clazz = n.nativeType.getClass();
		for (c in n.nodes) {
			c.nativeType = clazz.findField(c.name.name, false).type;
			c.superType = c.nativeType.getClass().module;
			if (c.id == null) c.oneInstance = true;
			postResolve(c);
		}
		
		return true;
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