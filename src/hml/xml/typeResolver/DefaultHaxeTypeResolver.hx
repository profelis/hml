package hml.xml.typeResolver;

import hml.xml.Data;
import haxe.macro.Context;

using hml.base.MacroTools;
using haxe.macro.Tools;

class DefaultHaxeTypeResolver implements IHaxeTypeResolver<Node, Type> {

    public var types:Map<String, Type>;

    public function new() {}

    public function getNativeType(node:Node):Null<haxe.macro.Type> {
        var superType = node.superType;
        while (types.exists(superType)) {
            node = types.get(superType);
            superType = node.superType;
        }

        var type;
        try {
            type = Context.getType(superType);
        } catch (e:Dynamic) {}
        if (node.generic != null) {
            switch (type) {
                case TAbstract(_, params) | TInst(_, params) | TEnum(_, params) | TType(_, params):
                    var types = null;
                    try {
                        types = node.generic.toTypeArray();
                    } catch (e:Dynamic) {}
                    if (types != null) {
                        while (params.length > 0) params.pop();
                        for (s in types) params.push(s);
                    }
                case _:
            }
        }
        return type;
    }

    public function getFieldNativeType(node:Node, qName:XMLQName):Null<haxe.macro.Type> {
        var type:Type;
        if ((type = types[node.superType]) != null) {
            for (n in type.children) if (qName.name == n.id) return n.nativeType;
            for (n in type.nodes) if (qName.name == n.id) return n.nativeType;
            for (n in type.declarations) if (qName.name == n.id) return n.nativeType;
            return getFieldNativeType(type, qName);
        }
        return try {
            Context.getType(node.superType).getClass().findField(qName.name, false).type;
        } catch (e:Dynamic) { null; }
    }
}
