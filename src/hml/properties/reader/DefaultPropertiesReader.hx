package hml.properties.reader;

import hml.base.StringUtils;
import hml.base.MatchLevel;
import hml.properties.Data;
import haxe.macro.Expr.Position;
import haxe.macro.Context;

using StringTools;

class DefaultPropertiesReader implements IPropertiesReader<PropertiesData> {

    public function new() {
    }

    public function match(data:String, fileName:String, pos:Position):MatchLevel {
        return MatchLevel.GlobalLevel;
    }

    public function read(data:String, fileName:String, pos:Position):PropertiesData {
        var res = new PropertiesData();

        var lines = StringUtils.splitLines(data);
        for (l in lines) {
            var arr = l.split("=");
            if (arr.length < 2) {
                Context.warning('skip line: $l', pos);
                continue;
            }
            var node = new PropertiesNodeData();
            node.key = arr[0].trim();
            node.value = arr[1];
            res.nodes.push(node);
        }

        return res;
    }
}
