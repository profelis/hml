package hml.properties;

import hml.base.Strings;
import hml.properties.writer.IPropertiesWriter;
import hml.base.Output;
import hml.base.IFileProcessor.WriterResult;
import hml.base.fileProcessor.IWriter;
import hml.properties.Data;
import haxe.io.Path;

import haxe.macro.Context;

using hml.base.MatchLevel;
using StringTools;
using sys.FileSystem;

class PropertiesWriter implements IWriter<PropertiesType> implements IPropertiesWriter<PropertiesNodeType> {

    public static inline var TAB = "    ";

    var writers:Array<IPropertiesNodeWriter<PropertiesNodeType>>;

    public var fields:Array<WriteNode<PropertiesNodeType>>;
    public var methods:Array<WriteNode<PropertiesNodeType>>;

    public function new(writers:Array<IPropertiesNodeWriter<PropertiesNodeType>>) {
        this.writers = writers;
        fields = [];
        methods = [];
    }

    public function write(types:Array<PropertiesType>, output:Output):WriterResult {
        var paths = [];

        for (type in types) {
            fields = [];
            methods = [];
//            destroyMethod = [];
            for (node in type.nodes) {
                var writer;
                #if hml_debug
                writer = writers.findMatch(function (p) return p.match(node));
                #else
                try {
                   writer = writers.findMatch(function (p) return p.match(node));
                } catch (e:Dynamic) {
                   Context.error(e, Context.currentPos());
                }
                #end
                writer.write(node, this);
            }

            var res = new Strings();
            var pos = type.model.type.lastIndexOf(".");
            var pack = pos > -1 ? type.model.type.substr(0, pos) : "";
            var name = pos > -1 ? type.model.type.substr(pos + 1) : type.model.type;

            res += 'package $pack;\n';
            res += '\n';

            res += 'class $name';
            res += ' {\n';

            inline function writeNode(f:WriteNode<Dynamic>) {
               var s = f.toString();
               s = '\n${TAB}${s.split("\t").join(TAB).split("\n").join("\n" + TAB)}\n';
               res += s;
            }

            for (f in fields) writeNode(f);
            for (f in methods) writeNode(f);

            res += '\n${TAB}public function new() {}';

            res += '\n}\n';

            var path = '${output.path}/${type.model.type.replace(".", "/")}';
            var p = new Path(path);
            p.ext = "hx";
            if (p.dir != null) p.dir.createDirectory();
            var file = p.toString();
            paths.push(p.toString().replace('${output.path}/', ""));

            if (!output.allowOverride && file.exists())
                Context.warning('can\'t override file "$file". File already exists. Use allowOverride for change settings.', Context.makePosition({file:file, min:0, max:0}));
            else
                sys.io.File.saveContent(file, res);
        }

        return {savedFiles:paths};
    }
}
