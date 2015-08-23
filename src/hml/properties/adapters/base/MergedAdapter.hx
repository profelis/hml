package hml.properties.adapters.base;

import hml.properties.writer.IPropertiesWriter.IPropertiesNodeWriter;
import hml.properties.typeResolver.IPropertiesParser.IPropertiesNodeParser;
import hml.properties.adapters.IPropertiesAdapter;
import hml.properties.reader.IPropertiesReader;

import haxe.macro.Expr;

class MergedAdapter<NB, B, NT, T> implements IPropertiesAdapter<NB, B, NT, T> {

    var adapters:Array<IPropertiesAdapter<NB, B, NT, T>>;

    public function new(adapters:Array<IPropertiesAdapter<NB, B, NT, T>>) {
        this.adapters = adapters;
    }

    public function getReaders():Array<IPropertiesReader<B>> {
        return foreach(getReaders);
    }

    public function getNodeParsers():Array<IPropertiesNodeParser<NB, NT, T>> {
        return foreach(getNodeParsers);
    }

    public function getNodeWriters():Array<IPropertiesNodeWriter<NT>> {
        return foreach(getNodeWriters);
    }

    macro static function foreach(methodExpr:Expr) {
        var method = switch (methodExpr.expr) {
            case EField(_, field): field;
            case EConst(CIdent(id)): id;
            case _: throw "assert";
        }
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