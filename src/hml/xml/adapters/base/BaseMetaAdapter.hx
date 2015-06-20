package hml.xml.adapters.base;

import hml.xml.writer.DefaultNodeWriter;
import hml.xml.typeResolver.IHaxeTypeResolver;
import hml.xml.writer.IHaxeWriter;
import hml.xml.adapters.base.BaseXMLAdapter;
import hml.xml.Data;
import hml.base.MatchLevel;

import haxe.macro.Expr;

using hml.base.MacroTools;

class MetaData {
	public var type:haxe.macro.Type;
	public var name:String;

	public function new(type:haxe.macro.Type, name:String) {
		this.type = type;
		this.name = name;
	}

	public function getExpr():Expr {
		return macro $v{name};
	}
}

interface IMetaWriter {
	public function writeMeta(node:Node, scope:String, metaData:MetaData, parent:Node, metaWriter:DefaultNodeWriter, writer:IHaxeWriter<Node>, method:Array<String>):Void;
}

class BaseMetaAdapter extends BaseXMLAdapter {

	var baseType:ComplexType;
	var meta:Map<String, MetaData>;
	var metaWriter:IMetaWriter;
	var matchLevel:MatchLevel;

	function new(baseType:ComplexType, meta:Map<String, MetaData>, metaWriter:IMetaWriter, matchLevel:MatchLevel) {
		super();
		this.baseType = baseType;
		this.meta = meta;
		this.metaWriter = metaWriter;
		this.matchLevel = matchLevel;
	}

	override public function getTypeResolvers():Array<IHaxeTypeResolver<Node, Type>> {
		return [new BaseMetaResolver(baseType, meta)];
	}

	override public function getNodeWriters():Array<IHaxeNodeWriter<Node>> {
		return [new BaseNodeWithMetaWriter(baseType, metaWriter, matchLevel)];
	}
}

class BaseMetaResolver implements IHaxeTypeResolver<Node, Type> {
	
	public var types:Map<String, Type>;

	var baseType:ComplexType;
	var meta:Map<String, MetaData>;

	public function new(baseType:ComplexType, meta:Map<String, MetaData>) {
		this.baseType = baseType;
		this.meta = meta;
	}

	@:extern static public inline function metaKey(qName:XMLQName):String {
		return metaKeyString(qName.name);
	}

	@:extern static public inline function metaKeyString(name:String):String {
		return "meta:" + name;
	}

	public function getNativeType(node:Node):haxe.macro.Type {
		return null;
	}

	public function isType(node:Node):Bool {
		return false;
	}
	
	public function getFieldNativeType(node:Node, qName:XMLQName):Null<haxe.macro.Type> {
		if (qName.ns != node.name.ns || !meta.exists(qName.name)) return null;

		return if (node.nativeType.isChildOf(baseType)) {
			var key = metaKey(qName);
			var extra:Map<XMLQName, MetaData> = node.extra[key];
			if (extra == null) node.extra[key] = extra = new Map();
			var res = meta.get(qName.name);
			extra.set(qName, res);
			res.type;
		} else null;
	}
}

class BaseNodeWithMetaWriter extends DefaultNodeWriter {
	
	var baseType:ComplexType;
	var meta:Map<String, MetaData>;
	var metaWriter:IMetaWriter;
	var matchLevel:MatchLevel;

	public function new(baseType:ComplexType, metaWriter:IMetaWriter, matchLevel:MatchLevel) {
		super();
		this.baseType = baseType;
		this.metaWriter = metaWriter;
		this.matchLevel = matchLevel;
	}

	override public function match(node:Node):MatchLevel {
		return isChildOf(node, baseType) ? matchLevel : None;
	}

	override function writeNodes(node:Node, scope:String, writer:IHaxeWriter<Node>, method:Array<String>) {
		for (a in node.nodes) {
			var events:Map<XMLQName, MetaData> = node.extra[BaseMetaResolver.metaKey(a.name)];
			if (events != null && events.exists(a.name)) {
				metaWriter.writeMeta(a, scope, events.get(a.name), node, this, writer, method);
				continue;
			}
			writer.writeAttribute(node, scope, a, method);
		}
	}
}