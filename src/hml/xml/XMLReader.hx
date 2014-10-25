package hml.xml;

import com.tenderowls.xml176.Xml176Parser;
import haxe.macro.Context;
import haxe.macro.Expr;
import hml.base.BaseFileProcessor;
import hml.xml.XMLProcessor;
import hml.base.MatchLevel;

using hml.base.MatchLevel;
using hml.xml.Data;
using StringTools;
using Reflect;
using Lambda;

class DefaultXMLElementParser implements IXMLNodeParser<XMLData> {
	public function new() {}

	public function match(xml:Xml176Document, parent:XMLData):MatchLevel {
		return switch (xml.document.nodeType) {
			case Xml.Element: GlobalLevel;
			default: None;
		};
	}

	public function parse(node:Xml176Document, parent:XMLData, parser:IXMLParser<XMLData>):XMLData {
		return parseData(new XMLData(), node, parent, parser);
	}

	function posToXMLDataPos(xml:Xml176Document, pos:Pos):XMLDataPos {
		var raw = xml.rawData;
		inline function getLinePos(pos:Int) {
			var s = raw.substr(0, pos).split("\r\n").join("\n");
			var lines = ~/[\r\n]/g.split(s);
			return {line:lines.length, pos:lines[lines.length-1].length};
		}
		return {
			from: getLinePos(pos.from),
			to: getLinePos(pos.to),
			min: pos.from,
			max: pos.to,
			file: xml.path
		}
	}

	function parseData(res:XMLData, xmlNode:Xml176Document, parent:XMLData, parser:IXMLParser<XMLData>) {
		var node = xmlNode.document;
		res.name = node.nodeName.toXMLQName();
		res.nodePos = posToXMLDataPos(xmlNode, xmlNode.getNodePosition(node));
		res.parent = parent;
		res.root = parent != null ? parent.root : null;

		for (a in node.attributes()) {
			var qName = a.toXMLQName();
			var value = node.get(a);
			inline function formatNS(value:String) return if (value.endsWith(".*")) value.substr(0, -2) else value;
			switch ({name:qName.name, ns:qName.ns}) {
				case {name:"xmlns", ns:null}: res.namespaces["*"] = formatNS(value);
				case {name:n, ns:"xmlns"}: res.namespaces[n] = formatNS(value);
				case _: 
					res.attributes.set(qName, value);
					res.attributesPos.set(qName, posToXMLDataPos(xmlNode, xmlNode.getAttrPosition(node, a)));
			}
		}

		for (c in node)
			switch (c.nodeType) {
				case Xml.PCData, Xml.CData:
					var data = c.nodeValue.trim();
					if (data.length > 0)
						res.cData = res.cData == null ? data : res.cData + data;

				default:
					var node = parser.parse(xmlNode.sub(c), res);
					if (node != null) res.nodes.push(node);
			}

		return res;
	}
}

class DefaultXMLDocumentParser extends DefaultXMLElementParser {
	override public function match(xml:Xml176Document, parent:XMLData):MatchLevel {
		return switch (xml.document.nodeType) {
			case Xml.Document: PackageLevel;
			default: None;
		};
	}

	override public function parse(node:Xml176Document, parent:XMLData, parser:IXMLParser<XMLData>):XMLData {
		var res = new XMLDataRoot();
		res.root = res;
		parseData(res, node.sub(node.document.firstElement()), res, parser);
		res.parent = null;
		return res;
	}
}

class XMLReader implements IReader<XMLDataRoot> implements IXMLParser<XMLData> {

	static var XML_EXT = ~/(.xml$)/;
	static var CLASS_ID = ~/[A-Z][a-z_A-Z0-9]*/;

	var nodeParsers:Array<IXMLNodeParser<XMLData>>;

	public function new(nodeParsers:Array<IXMLNodeParser<XMLData>>) {
		this.nodeParsers = nodeParsers;
	}

	function getTypeName(path:String, root:String):String {
		var res = path.replace(root, "");
		res = ~/[\/\\]/g.replace(res, ".");
		res = XML_EXT.replace(res, "");
		if (res.startsWith(".")) res = res.substring(1);
		
		var lastDot = res.lastIndexOf(".");
		var t = lastDot == -1 ? res : res.substr(lastDot + 1);
		if (!(CLASS_ID.match(t)))
			Context.error('file name can\'t be used as class name', Context.makePosition({min:0, max:0, file:path}));
		return res;
	}

	public function read(file:String, pos:Position, root:String):XMLDataRoot {
		var cont;
		var xml:Xml176Document;

		try {
			cont = sys.io.File.getContent(file);
		} catch (e:Dynamic) {
			Context.error('can\'t read file "$file" content', pos);
		}
		try {
			xml = Xml176Parser.parse(cont, file);
		} catch (e:XmlParserError) {
			Context.error('${e.text}', Context.makePosition({min:e.from, max:e.to, file:file}));
		} catch (e:Dynamic) {
			Context.error('${Std.string(e)}', Context.makePosition({min:0, max:0, file:file}));
		}

		Context.registerModuleDependency("hml.Hml", file);
		return readXML(xml, file, pos, root);
	}

	function readXML(xml:Xml176Document, file:String, pos:Position, root:String):XMLDataRoot {
		var res:XMLDataRoot = cast parse(xml, null);
		res.type = getTypeName(file, root);
		res.file = file;
		res.pos = pos;
		return res;
	}

	public function parse(node:Xml176Document, parent:XMLData):Null<XMLData> {
		var nodeParser;
		try {
			nodeParser = nodeParsers.findMatch(function (p) return p.match(node, parent));
		} catch(e:Dynamic) {
			Context.error(e, Context.currentPos());
		}
		if (nodeParser == null) {
			#if hml_debug
			var pos = node.getNodePosition(node.document);
			Context.warning('ignored node: ${node.document}', Context.makePosition({file:node.path, min:pos.from, max:pos.to}));
			#end
			return null;
		}
		var res;
		try {
			res = nodeParser.parse(node, parent, this);
		} catch (e:Dynamic) {
			var pos = node.getNodePosition(node.document);
			Context.error(e, Context.makePosition({min:pos.from, max:pos.to, file:parent.root.nodePos.file}));
		}
		return res;
	}
}