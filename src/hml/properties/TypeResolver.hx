package hml.properties;

import hml.properties.typeResolver.IPropertiesParser;
import hml.base.fileProcessor.ITypeResolver;
import hml.properties.Data;
import haxe.macro.Context;

using hml.base.MatchLevel;

class TypeResolver implements ITypeResolver<PropertiesData, PropertiesType> implements IPropertiesParser<PropertiesData, PropertiesType> {

    var parsers:Array<IPropertiesNodeParser<PropertiesNodeData, PropertiesNodeType, PropertiesType>>;

    public function new(parsers:Array<IPropertiesNodeParser<PropertiesNodeData, PropertiesNodeType, PropertiesType>>) {
        this.parsers = parsers;
    }

    public function resolve(data:Array<PropertiesData>):Array<PropertiesType> {
        var res = [];

        for (d in data) {
            var t = parse(d);
            res.push(t);
        }

        return res;
    }

    public function parse(data:PropertiesData):PropertiesType {
        var res = new PropertiesType();
        res.model = data;

        for (node in data.nodes) {
            var nodeParser;
            try {
                nodeParser = parsers.findMatch(function (p) return p.match(node, res));
            } catch(e:Dynamic) {
                Context.error(e, Context.currentPos());
            }
            var n = nodeParser.parse(node, res);
            if (n != null) res.nodes.push(n);
            else Context.warning('Can\'t resolve node $node', Context.currentPos());
        }

        return res;
    }
}
