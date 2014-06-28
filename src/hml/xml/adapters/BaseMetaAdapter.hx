package hml.xml.adapters;

import hml.base.MacroTools;
import hml.xml.Data;
import hml.xml.XMLProcessor;
import hml.xml.XMLWriter;
import hml.base.MatchLevel;

import haxe.macro.Context;
import haxe.macro.Expr;

class MetaData {
	public var type:haxe.macro.Type;

	public function new(type:haxe.macro.Type) {
		this.type = type;
	}
}

interface IMetaWriter {
	public function writeMeta(node:Node, scope:String, parent:Node, metaWriter:MetaWriter, writer:IHaxeWriter<Node>, method:Array<String>):Void;
}

class BaseMetaAdapter extends BaseXMLAdapter {

	var baseType:ComplexType;
	var meta:Map<String, MetaData>;
	var metaWriter:IMetaWriter;
	var matchLevel:MatchLevel;

	public function new(baseType:ComplexType, meta:Map<String, MetaData>, metaWriter:IMetaWriter, matchLevel:MatchLevel) {
		super();
		this.baseType = baseType;
		this.meta = meta;
		this.metaWriter = metaWriter;
		this.matchLevel = matchLevel;
	}

	override public function getTypeResolvers():Array<IHaxeTypeResolver<Node, Type>> {
		return [new MetaResolver(baseType, meta)];
	}

	override public function getNodeWriters():Array<IHaxeNodeWriter<Node>> {
		return [new MetaWriter(baseType, meta, metaWriter, matchLevel)];
	}
}

class MetaResolver implements IHaxeTypeResolver<Node, Type> {
	
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
	
	public function hasField(node:Node, qName:XMLQName):Bool {
		if (qName.ns != node.name.ns || !meta.exists(qName.name)) return false;

		return if (MacroTools.isChildOf(node.nativeType, baseType)) {
			var key = metaKey(qName);
			var events:Map<XMLQName, MetaData> = node.extra[key];
			if (events == null) node.extra[key] = events = new Map();
			events.set(qName, meta.get(qName.name));
			return true;
		} else false;
	}
	
	public function getFieldNativeType(node:Node, qName:XMLQName):haxe.macro.Type {
		var events:Map<XMLQName, MetaData> = node.extra[metaKey(qName)];
		return events != null && events.exists(qName) ? meta[qName.name].type : null;
	}
}

class MetaWriter extends DefaultNodeWriter {
	
	var baseType:ComplexType;
	var meta:Map<String, MetaData>;
	var metaWriter:IMetaWriter;
	var matchLevel:MatchLevel;

	public function new(baseType:ComplexType, meta:Map<String, MetaData>, metaWriter:IMetaWriter, matchLevel:MatchLevel) {
		super();
		this.baseType = baseType;
		this.meta = meta;
		this.metaWriter = metaWriter;
		this.matchLevel = matchLevel;
	}

	override public function match(node:Node):MatchLevel {
		return isChildOf(node, baseType) ? matchLevel : None;
	}

	override function writeNodes(node:Node, scope:String, writer:IHaxeWriter<Node>, method:Array<String>) {
		for (a in node.nodes) {
			if (meta.exists(a.name.name)) {
				var events:Map<XMLQName, MetaData> = node.extra[MetaResolver.metaKey(a.name)];
				if (events != null && events.exists(a.name)) {
					metaWriter.writeMeta(a, scope, node, this, writer, method);
					continue;
				}
			}
			writer.writeAttribute(node, scope, a, method);
		}
	}
}