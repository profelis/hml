package hml.xml.typeResolver;

import hml.xml.typeResolver.IHaxeTypeResolver;
import hml.base.MatchLevel;
import hml.xml.Data;

using hml.base.MacroTools;

class DefaultXMLDataRootParser extends DefaultXMLDataParser implements IXMLDataNodeParser<XMLData, Node, Type> {

    override public function match(data:XMLData, parent:Node):MatchLevel {
        return Std.is(data, XMLDataRoot) ? ClassLevel : None;
    }

    override function processSpecificNamespace(name:XMLQName, node:Node, ?child:Node, ?cData:String, pos:XMLDataPos):Bool {
        inline function data() return child != null ? child.cData : cData;

        var res = false;
        switch (node.model.resolveNamespace(name.ns)) {
            case DefaultXMLDataParser.HAXE_NAMESPACE:
            switch (name.name) {
                case "implements":
                    cast(node, Type).implementsList = data().stringToTypes();
                    res = true;
                case _:
            }
            case _:
        }

        return res ? res : super.processSpecificNamespace(name, node, child, cData, pos);
    }

    override public function parse(data:XMLData, parent:Node, parser:IXMLDataParser<XMLData, Node>):Type {
        var root:XMLDataRoot = cast data;

        var type = new Type();
        type.root = type;
        type.file = root.file;
        type.pos = root.pos;
        type.type = root.type;
        type.parent = null;

        parseNode(type, root, parser);

        type.id = "this";
        type.idSetted = true;

        return type;
    }
}
