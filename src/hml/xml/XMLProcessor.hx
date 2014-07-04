package hml.xml;

import com.tenderowls.xml176.Xml176Parser;
import hml.base.BaseFileProcessor;
import hml.Hml.Output;
import haxe.macro.Expr;
import hml.xml.Data;
import hml.xml.TypeResolver;
import hml.xml.XMLReader;
import hml.xml.XMLWriter;
import hml.base.MatchLevel;

using hml.base.MatchLevel;

// reader
interface IXMLParser<B> {
	public function parse(xml:Xml176Document, parent:B):B;
}

interface IXMLNodeParser<B> {
	public function match(xml:Xml176Document, parent:B):MatchLevel;
	public function parse(xml:Xml176Document, parent:B, parser:IXMLParser<B>):B;
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
	public function isType(node:N):Bool;
	public function hasField(node:N, qName:XMLQName):Bool;
	public function getFieldNativeType(node:N, qName:XMLQName):haxe.macro.Type;
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

	public function getXmlNodeParsers():Array<IXMLNodeParser<XMLData>> {
		return [new DefaultXMLNodeParser(), new DefaultXMLDocumentParser()];
	}
	public function getXmlDataNodeParsers():Array<IXMLDataNodeParser<XMLData, Node, Node>> {
		return [new DefaultXMLDataParser(), new DefaultXMLDataRootParser()];
	}
	public function getTypeResolvers():Array<IHaxeTypeResolver<Node, Type>> {
		return [new DefaultHaxeTypeResolver()];
	}
	public function getNodeWriters():Array<IHaxeNodeWriter<Node>> {
		return [new DefaultArrayWriter(), new DefaultNodeWriter(), new DefaultStringWriter(), new DefaultFunctionWriter()];
	}
}

class MergedAdapter<B, N, T> implements IAdapter<B, N, T> {
	public var adapters:Array<IAdapter<B, N, T>>;

	public function new(adapters:Array<IAdapter<B, N, T>>) {
		this.adapters = adapters;
	}

	public function getXmlNodeParsers():Array<IXMLNodeParser<B>> {
		return foreach("getXmlNodeParsers");
	}

	public function getXmlDataNodeParsers():Array<IXMLDataNodeParser<B, N, N>> {
		return foreach("getXmlDataNodeParsers");
	}

	public function getTypeResolvers():Array<IHaxeTypeResolver<N, T>> {
		return foreach("getTypeResolvers");
	}

	public function getNodeWriters():Array<IHaxeNodeWriter<N>> {
		return foreach("getNodeWriters");
	}

	macro static function foreach(method:String) {
		return macro {
			var res = [];
			for (a in adapters) {
				var t = a.$method();
				if (t != null) res = res.concat(t);
			}
			res;
		}
	}
}

class XMLProcessor extends BaseFileProcessor<XMLDataRoot, Type> {

	static var XML_EXT = ~/.xml$/;

	public function new(adapters:Array<IAdapter<XMLData, Node, Type>>) {
		var merged = new MergedAdapter<XMLData, Node, Type>(adapters);
		super(
			new XMLReader(merged.getXmlNodeParsers()), 
			new TypeResolver(merged.getXmlDataNodeParsers(), merged.getTypeResolvers()), 
			new XMLWriter(merged.getNodeWriters())
		);
	}

	override public function supportFile(file:String):Bool {
		return XML_EXT.match(file);
	}
}