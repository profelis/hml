package hml.xml;

import hml.xml.reader.IXMLParser;
import hml.base.fileProcessor.IReader;
import com.tenderowls.xml176.Xml176Parser;
import haxe.macro.Context;
import haxe.macro.Expr;

using hml.base.MatchLevel;
using hml.xml.Data;
using StringTools;

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
            #if hml_debug
            trace(e.text);
            #end
			Context.error('${e.text}', Context.makePosition({min:e.from, max:e.to, file:file}));
		} catch (e:Dynamic) {
            #if hml_debug
            trace(e);
            #end
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
			#if hml_warn
			var pos = node.getNodePosition(node.document);
			Context.warning('Ignored node: ${node.document}', Context.makePosition({file:node.path, min:pos.from, max:pos.to}));
			#end
			return null;
		}
		var res;
        #if hml_debug
        res = nodeParser.parse(node, parent, this);
        #else
		try {
			res = nodeParser.parse(node, parent, this);
		} catch (e:Dynamic) {
			var pos = node.getNodePosition(node.document);
			Context.error(e, Context.makePosition({min:pos.from, max:pos.to, file:parent.root.nodePos.file}));
		}
        #end
		return res;
	}
}