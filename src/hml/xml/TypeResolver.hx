package hml.xml;

import hml.xml.typeResolver.IHaxeTypeResolver;
import hml.base.fileProcessor.ITypeResolver;
import haxe.macro.Context;
import hml.xml.Data;

using hml.base.MatchLevel;
using Lambda;


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

        resolveTypes(resolveNode);
		if (!resolveTypes(recursiveResolve))
			types.iter(throwResolveError);

		if (!resolveTypes(postResolve))
			Context.error('can\'t resolve node native types. Please send error report to deep (system.grand<at>gmail.com).', Context.currentPos());

		return [for (t in types) t];
	}

	function resolveTypes(resolveMethod:Node->Bool, n = 10):Bool {
		var i = 0;
		var flag = true;
		while (i++ < n) {
			for (t in types) flag = resolveMethod(t) && flag;
            if (flag) break;
		}
		#if hml_debug
		trace("iterations: " + i + " flag: " + flag);
		#end
		return flag;
	}

	function throwResolveError(t:Node) {
        for (n in t.unresolvedNodes)
                Context.error('can\'t resolve node "${n.name}". Can\'t find haxe type or field with same name.', Context.makePosition(n.model.nodePos));
        
        if (Std.is(t, Type))  cast(t, Type).declarations.iter(throwResolveError);
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
				var fieldType = getFieldNativeType(t, n.name);
				if (fieldType != null) {
					removeItem(i);
					n.nativeType = fieldType;
					t.nodes.push(n);
				} else if (n.nativeType != null) {
					removeItem(i);
					var children = t.children;
					var len = children.length;
					if (len == 0)
						children.push(n);
					else {
						var pos = 0;
						var targetIndex = n.model.index;
						while (pos < len && children[pos].model.index <= targetIndex) pos++;
						if (pos < len) children.insert(pos, n); else children.push(n);
					}
				} else {
					i++;
				}
			}
		}
		return t.unresolvedNodes.length == 0;
	}

	function recursiveResolve(n:Node):Bool {
		var res = resolveNode(n);

        inline function iterNodes(nodes:Array<Node>)
            for (c in nodes) res = recursiveResolve(c) && res;

        iterNodes(n.children);
        iterNodes(n.nodes);
        if (Std.is(n, Type)) 
            for (d in (cast(n, Type).declarations)) {
                if (d.nativeType == null) d.nativeType = getNativeType(d);
                res = recursiveResolve(d) && res;
            }
        return res;
	}

	function postResolve(n:Node):Bool {
		if (n.nativeType == null) n.nativeType = getNativeType(n);
		if (n.nativeType == null) return false;
		var res = true;

		inline function processNode(node:Node) res = postResolve(node) && res;
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

	function getFieldNativeType(node:Node, qName:XMLQName):haxe.macro.Type {
		for (r in resolvers) {
			var res = r.getFieldNativeType(node, qName);
			if (res != null) return res;
		}
		return null;
	}
}