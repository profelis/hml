package hml.properties;

import hml.properties.reader.IPropertiesReader;
import hml.base.MatchLevel;
import hml.base.fileProcessor.IReader;
import hml.properties.Data;
import haxe.macro.Expr.Position;
import haxe.macro.Context;

using hml.base.MatchLevel;
using StringTools;

class PropertiesReader implements IReader<PropertiesData> {

    var readers:Array<IPropertiesReader<PropertiesData>>;

    public function new(readers:Array<IPropertiesReader<PropertiesData>>) {
        this.readers = readers;
    }

    public function read(file:String, pos:Position, root:String):PropertiesData {
        var cont:String = null;
        try {
            cont = sys.io.File.getContent(file);
        } catch (e:Dynamic) {
            Context.error('can\'t read file "$file" content', pos);
        }

        var nodeReader;
        try {
            nodeReader = readers.findMatch(function (p) return p.match(cont, file, pos));
        } catch(e:Dynamic) {
            Context.error(e, pos);
        }
        var res = nodeReader.read(cont, file, pos);
        res.file = file;
        res.type = getTypeName(file, root);

        return res;
    }

    static var PROPERTIES_EXT = ~/.properties$/;
    static var CLASS_ID = ~/[A-Z][a-z_A-Z0-9]*/;

    function getTypeName(path:String, root:String):String {
        var res = new EReg(root, "").replace(path, "");
        res = ~/[\/\\]/g.replace(res, ".");
        res = PROPERTIES_EXT.replace(res, "");
        if (res.startsWith(".")) res = res.substring(1);

        var lastDot = res.lastIndexOf(".");
        var t = lastDot > -1 ? res.substr(lastDot + 1) : res;
        var pack = lastDot > -1 ? res.substr(0, lastDot) : "";
        t = t.charAt(0).toUpperCase() + t.substr(1);

        if (!(CLASS_ID.match(t)))
            Context.error('file name can\'t be used as class name', Context.makePosition({min:0, max:0, file:path}));
        return pack + "." + t;
    }
}
