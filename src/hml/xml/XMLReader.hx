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

class DefaultXMLNodeParser implements IXMLNodeParser<XMLData> {
	public function new() {}

	public function match(xml:Xml176Document, parent:XMLData):MatchLevel {
		return GlobalLevel;
	}

	public function parse(node:Xml176Document, parent:XMLData, parser:IXMLParser<XMLData>):XMLData {
		return parseData(new XMLData(), node, parent, parser);
	}

	function posToXMLDataPos(xml:Xml176Document, pos:Pos):XMLDataPos {
		var raw = xml.rawData;
		inline function getLinePos(pos:Int) {
			var s = raw.substr(0, pos);
			var lines = ~/[\r\n]/g.split(s);
			return {global:pos, line:lines.length, pos:lines[lines.length-1].length};
		}
		return {
			from: getLinePos(pos.from),
			to: getLinePos(pos.to)
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

				case Xml.Element:
					res.nodes.push(parser.parse(xmlNode.sub(c), res));
				default:
			}

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

	function getTypeName(path:String):String {
		var res = ~/[\/\\]/g.replace(path, ".");
		res = ~/(\w*\.)/.replace(res, "");
		res = XML_EXT.replace(res, "");
		
		var lastDot = res.lastIndexOf(".");
		var t = lastDot == -1 ? res : res.substr(lastDot + 1);
		if (!(CLASS_ID.match(t)))
			Context.error('file name can\'t be used as class name "$path"', Context.currentPos());
		return res;
	}

	public function read(file:String, pos:Position):XMLDataRoot {
		var cont;
		var xml:Xml176Document;

		tryCatch(cont = sys.io.File.getContent(file), Context.fatalError('can\'t read file "$file" content', pos));
		tryCatch(xml = Xml176Parser.parse(cont), Context.fatalError('can\'t parse XML "$file"', pos));

		Context.registerModuleDependency("hml.Hml", file);
		return readXML(xml, file, pos);
	}

	function readXML(xml:Xml176Document, file:String, pos:Position):XMLDataRoot {
		var res = new XMLDataRoot();
		res.type = getTypeName(file);
		res.file = file;
		res.pos = pos;
		res.root = res;
		var node = parse(xml.sub(xml.document.firstElement()), null);
		for (n in node.fields()) res.setField(n, node.field(n));
		return res;
	}

	public function parse(node:Xml176Document, parent:XMLData):XMLData {
		var nodeParser = nodeParsers.findMatch(function (p) return p.match(node, parent));
		return nodeParser.parse(node, parent, this);
	}

	macro function tryCatch(expr:Expr, catchExpr:Expr):Expr return
		macro try $expr catch (e:Dynamic) {
			#if hml_debug trace(e); #end
			$catchExpr;
		};
}