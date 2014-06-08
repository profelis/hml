package hml.xml;

import hml.base.BaseFileProcessor;
import hml.Hml.Output;
import haxe.macro.Expr;
import hml.xml.Data;
import hml.xml.TypeResolver;
import hml.xml.XMLReader.DefaultXMLNodeParser;
import hml.xml.XMLWriter;
import hml.base.MatchLevel;

using hml.base.MatchLevel;

// reader
interface IXMLParser<B> {
	public function parse(xml:Xml, parent:B):B;
}

interface IXMLNodeParser<B> {
	public function match(xml:Xml, parent:B):MatchLevel;
	public function parse(xml:Xml, parent:B, parser:IXMLParser<B>):B;
}

// type resolver
interface IXMLDataParser<B, T> {
	public function parse(data:B, parent:T):T;
}

interface IXMLDataNodeParser<B, T, R> {
	public function match(data:B, parent:T):MatchLevel;
	public function parse(data:B, parent:T, parser:IXMLDataParser<B, T>):R;
}

interface IHaxeTypeResolver<N, T> {
	public var types:Map<String, T>;
	public function getNativeType(node:N):haxe.macro.Type;
	public function isType(node:Node):Bool;
	public function hasField(node:Node, qName:XMLQName):Bool;
	public function getFieldNativeType(node:Node, qName:XMLQName):haxe.macro.Type;
}

// writer
class WriteNode<T> {
	public function toString():String { throw "override me"; }
	public var node:T;
}

interface IHaxeWriter<T> {
	public var fields:Array<WriteNode<T>>;
	public var methods:Array<WriteNode<T>>;
  	public function writeNode(node:T):Void;
  	public function writeAttribute(node:T, scope:String, child:T, method:Array<String>):Void;
}

interface IHaxeNodeWriter<T> {
  	public function match(node:T):MatchLevel;
  	public function write(node:T, writer:IHaxeWriter<T>):Void;
  	public function writeAttribute(node:T, scope:String, child:T, writer:IHaxeWriter<T>, method:Array<String>):Void;
}

// adapter
interface IAdapter<B, N, T> {
	public function getXmlNodeParsers():Array<IXMLNodeParser<B>>;
	public function getXmlDataNodeParsers():Array<IXMLDataNodeParser<B, N, N>>;
	public function getTypeResolvers():Array<IHaxeTypeResolver<N, T>>;
	public function getNodeWriters():Array<IHaxeNodeWriter<N>>;
}

class BaseXMLAdapter implements IAdapter<XMLData, Node, Type> {
	public function new() {}

	public function getXmlNodeParsers():Array<IXMLNodeParser<XMLData>> return null;
	public function getXmlDataNodeParsers():Array<IXMLDataNodeParser<XMLData, Node, Node>> return null;
	public function getTypeResolvers():Array<IHaxeTypeResolver<Node, Type>> return null;
	public function getNodeWriters():Array<IHaxeNodeWriter<Node>> return null;	
}

class DefaultXMLAdapter implements IAdapter<XMLData, Node, Type> {
	public function new() {}

	public function getXmlNodeParsers():Array<IXMLNodeParser<XMLData>> return [new DefaultXMLNodeParser()];
	public function getXmlDataNodeParsers():Array<IXMLDataNodeParser<XMLData, Node, Node>> return [new DefaultXMLDataParser()];
	public function getTypeResolvers():Array<IHaxeTypeResolver<Node, Type>> return [new DefaultHaxeTypeResolver()];
	public function getNodeWriters():Array<IHaxeNodeWriter<Node>> return [new DefaultArrayWriter(), new DefaultNodeWriter(), new DefaultStringWriter()];
}

class SpriteXMLAdapter extends BaseXMLAdapter {
	override public function getNodeWriters():Array<IHaxeNodeWriter<Node>> return [new DefaultSpriteWriter()];
}

class XMLProcessor extends BaseFileProcessor<XMLDataRoot, Type> {

	public function new(adapters:Array<IAdapter<XMLData, Node, Type>>) {
		var xmlNodeParsers = [];
		var xmlDataNodeParsers = [];
		var typeResolvers = [];
		var nodeWriters = [];
		for (a in adapters) {
			concatNotNullArray(xmlNodeParsers, a.getXmlNodeParsers());
			concatNotNullArray(xmlDataNodeParsers, a.getXmlDataNodeParsers());
			concatNotNullArray(typeResolvers, a.getTypeResolvers());
			concatNotNullArray(nodeWriters, a.getNodeWriters());
		}
		super(
			new XMLReader(xmlNodeParsers), 
			new TypeResolver(xmlDataNodeParsers, typeResolvers), 
			new XMLWriter(nodeWriters)
		);
	}

	macro static function concatNotNullArray(array, sub) {
		return macro {
			var t = $sub;
			if (t != null) $array = $array.concat(t);
		};
	}

	static var XML_EXT = ~/.xml$/;

	override public function supportFile(file:String):Bool return XML_EXT.match(file);
}