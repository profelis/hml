package hml.xml;

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
	public function match(xml:Xml, parent:XMLData):MatchLevel return GlobalLevel;

	public function parse(node:Xml, parent:XMLData, parser:IXMLParser<XMLData>):XMLData {
		return parseData(new XMLData(), node, parent, parser);
	}

	function parseData(res:XMLData, node:Xml, parent:XMLData, parser:IXMLParser<XMLData>) {
		res.name = node.nodeName.toXMLQName();
		res.parent = parent;
		res.root = parent != null ? parent.root : null;

		for (a in node.attributes()) {
			var qName = a.toXMLQName();
			var value = node.get(a);
			if (value.endsWith(".*")) value = value.substr(0, -2);
			switch ({name:qName.name, ns:qName.ns}) {
				case {name:"xmlns", ns:null}: res.namespaces["*"] = value;
				case {name:n, ns:"xmlns"}: res.namespaces[n] = value;
				case _: res.attributes.set(qName, value);
			}
		}

		for (c in node)
			switch (c.nodeType) {
				case Xml.PCData, Xml.CData:
					var data = c.nodeValue.trim();
					if (data.length > 0)
						res.cData = res.cData == null ? data : res.cData + data;

				case Xml.Element:
					res.nodes.push(parser.parse(c, res));
				default:
			}

		return res;
	}
}

class XMLReader implements IReader<XMLDataRoot> implements IXMLParser<XMLData> {

	var nodeParsers:Array<IXMLNodeParser<XMLData>>;

	public function new(nodeParsers:Array<IXMLNodeParser<XMLData>>) {
		this.nodeParsers = nodeParsers;
	}

	static var XML_EXT = ~/(.xml$)/;

	function getTypeName(path:String):String {
		var res = ~/[\/\\]/g.replace(path, ".");
		res = ~/(\w*\.)/.replace(res, "");
		// TODO: match fileName -> safeName
		res = XML_EXT.replace(res, "");
		return res;
	}

	public function read(file:String, pos:Position):XMLDataRoot {
		var cont;
		var xml:Xml;

		tryCatch(cont = sys.io.File.getContent(file), Context.fatalError('can\'t read file "$file" content', pos));
		tryCatch(xml = Xml.parse(cont), Context.fatalError('can\'t parse XML "$file"', pos));

		Context.registerModuleDependency("hml.Hml", file);
		return readXML(xml, file, pos);
	}

	function readXML(xml:Xml, file:String, pos:Position):XMLDataRoot {
		var res = new XMLDataRoot();
		res.type = getTypeName(file);
		res.file = file;
		res.pos = pos;
		res.root = res;
		var node = parse(xml.firstElement(), null);
		for (n in node.fields()) res.setField(n, node.field(n));
		return res;
	}

	public function parse(node:Xml, parent:XMLData):XMLData {
		var nodeParser = nodeParsers.findMatch(function (p) return p.match(node, parent));
		return nodeParser.parse(node, parent, this);
	}

	macro function tryCatch(expr:Expr, catchExpr:Expr):Expr return
		macro try $expr catch (e:Dynamic) {
			#if hml_debug trace(e); #end
			$catchExpr;
		};
}