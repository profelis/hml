package hml.xml;

import hml.base.Output;
import hml.xml.writer.IHaxeWriter;
import hml.base.fileProcessor.IWriter;
import haxe.macro.Context;
import hml.base.Strings;
import hml.base.Output;
import haxe.io.Path;
import hml.xml.Data;
import hml.base.MatchLevel;

using hml.base.MatchLevel;
using sys.FileSystem;
using StringTools;
using haxe.macro.Context;
using hml.base.MacroTools;

class XMLWriter implements IWriter<Type> implements IHaxeWriter<Node> {

	public static inline var TAB = "    ";

	public function new(writers:Array<IHaxeNodeWriter<Node>>) {
		this.writers = writers;
	}

	var writers:Array<IHaxeNodeWriter<Node>>;

	var output:Output;

	public function write(types:Array<Type>, output:Output):Void {
		this.output = output;

		for (type in types) {
			fields = [];
			methods = [];

			writeNode(type);

			var res = new Strings();

            var imports:Null<String> = null;
            var script:Null<String> = null;
            if (type.script != null) {
                var importsEReg = ~/^\s*(import|using)\s[\w.]+.*/gm;

                script = importsEReg.map(type.script, function (e) {
                    if (imports == null) imports = "";
                    imports += e.matched(0).trim() + "\n";
                    return "";
                });
            }

			var pos = type.type.lastIndexOf(".");
			var pack = pos > -1 ? type.type.substr(0, pos) : "";
			var name = pos > -1 ? type.type.substr(pos + 1) : type.type;
			res += 'package $pack;\n';
			res += '\n';

            if (imports != null) res += '$imports\n';
            if (type.meta != null) res += '${type.meta}\n';
			res += 'class $name extends ${type.superType}';
			if (type.implementsList != null) {
				for (i in type.implementsList)
					res += ' implements ${[i].typesToString()}';
			}
			res += ' {\n';
			inline function writeNode(f:WriteNode<Dynamic>) {
				var s = f.toString();
				s = '\n${TAB}${s.split("\n").join("\n" + TAB)}\n';
				res += s;
			}
			for (f in fields) writeNode(f);
			for (f in methods) writeNode(f);
            if (script != null) {
                res += '\n${TAB}${script}\n';
            }
			res += '}\n';

			var path = '${output.path}/${type.type.replace(".", "/")}';
			var p = new Path(path);
			if (p.dir != null) p.dir.createDirectory();
			p.ext = "hx";
            var file = p.toString();
            if (!output.allowOverride && file.exists())
                Context.warning('can\'t override file "$file". File already exists. Use allowOverride for change settings.', Context.makePosition({file:file, min:0, max:0}));
			else
                sys.io.File.saveContent(p.toString(), res);
		}
	}

	public var fields:Array<WriteNode<Node>>;
	public var methods:Array<WriteNode<Node>>;

	public function writeNode(node:Node):Void {
		var writer;
        #if hml_debug
        writer = writers.findMatch(function (p) return p.match(node));
        #else
		try {
			writer = writers.findMatch(function (p) return p.match(node));
		} catch (e:Dynamic) {
			Context.error(e, Context.makePosition(node.model.nodePos));
		}
        #end
		return writer.write(node, this);
	}

	public function writeAttribute(node:Node, scope:String, child:Node, method:Array<String>):Void {
		var writer;
        #if hml_debug
        writer = writers.findMatch(function (p) return p.match(child));
        #else
		try {
			writer = writers.findMatch(function (p) return p.match(child));
		} catch(e:Dynamic) {
			Context.error(e, Context.makePosition(child.model.nodePos));
		}
        #end
		writer.writeAttribute(node, scope, child, this, method);
	}
}