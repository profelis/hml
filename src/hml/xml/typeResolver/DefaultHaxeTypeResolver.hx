package hml.xml.typeResolver;

import hml.xml.Data;
import haxe.macro.Context;
import haxe.macro.Type.Type in MacroType;

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
        var name = qName.name;
        var dotIndex = name.indexOf(".");
        var superType = node.superType;
        while (dotIndex > -1) {
            var tName = name.substring(0, dotIndex);
            name = name.substring(dotIndex + 1);
            var type = _getFieldNativeType(superType, tName);
            if (type == null) return null;
            superType = type.toString();
            dotIndex = name.indexOf(".");
        }

        return _getFieldNativeType(superType, name);
    }

    function _getFieldNativeType(superType:String, name:String):Null<haxe.macro.Type> {
        var type:Type;
        if ((type = types[superType]) != null) {
            for (n in type.children) if (name == n.id) return n.nativeType;
            for (n in type.nodes) if (name == n.id) return n.nativeType;
            for (n in type.declarations) if (name == n.id) return n.nativeType;

            for (n in type.children) {
                var node = getNodeById(n, name);
                if (node != null) return node.nativeType;
            }
            for (n in type.nodes) {
                var node = getNodeById(n, name);
                if (node != null) return node.nativeType;
            }
            for (n in type.declarations) {
                var node = getNodeById(n, name);
                if (node != null) return node.nativeType;
            }
            return _getFieldNativeType(type.superType, name);
        }
        return try {
            var superTypeEnum = Context.getType(superType);
            switch (superTypeEnum) {
                case TAbstract(ref, _):
                    ref.get().findField(name).type;
                case _:
                    superTypeEnum.getClass().findField(name, false).type;
            }
        } catch (e:Dynamic) { null; }
    }

    function getNodeById(node:Node, name:String):Node {
        for (n in node.children) if (n.id == name) return n;
        for (n in node.nodes) if (n.id == name) return n;

        for (n in node.children)
        {
            var res = getNodeById(n, name);
            if (res != null) return res;
        }
        for (n in node.nodes) {
            var res = getNodeById(n, name);
            if (res != null) return res;
        }
        return null;
    }
}
