package hml.xml.typeResolver;

import haxe.macro.Context;
import hml.base.MatchLevel;
import hml.xml.typeResolver.IHaxeTypeResolver;
import hml.xml.Data;

using hml.base.MacroTools;

class DefaultXMLDataParser implements IXMLDataNodeParser<XMLData, Node, Node> {

    static public inline var HAXE_NAMESPACE = "http://haxe.org/";

    public function new() {}

    public function match(data:XMLData, parent:Node):MatchLevel {
        return GlobalLevel;
    }

    function isID(qName:XMLQName):Bool {
        return qName.ns == null && qName.name == "id";
    }

    public function parse(data:XMLData, parent:Node, parser:IXMLDataParser<XMLData, Node>):Node {
        var node = new Node();
        node.root = parent.root;
        node.parent = parent;
        parseNode(node, data, parser);
        return node;
    }

    function parseNode(node:Node, data:XMLData, parser:IXMLDataParser<XMLData, Node>) {
        node.superType = data.resolveType(data.name);
        if (node.superType == null)
            Context.error('can\'t resolve namespace', Context.makePosition(data.nodePos));

        node.model = data;
        node.name = data.name;
        node.cData = data.cData;

        parseAttributes(node, data, parser);
        parseNodes(node, data, parser);
    }

    function processSpecificNamespace(name:XMLQName, node:Node, ?child:Node, ?cData:String, pos:XMLDataPos):Bool {
        inline function data() return child != null ? child.cData : cData;
        var res = false;
        switch (node.model.resolveNamespace(name.ns)) {
            case HAXE_NAMESPACE:
                switch (name.name) {
                    case "generic":
                        node.generic = data().stringToTypes();
                        res = true;
                    case "Meta":
                        node.meta = if (node.meta == null) data(); else node.meta + '\n' + data();
                        res = true;
                    case _:
                        Context.error('unknown specific haxe attribute "${name}"', Context.makePosition(pos));
                }
            case _:
        }
        return res;
    }

    function parseAttributes(node:Node, data:XMLData, parser:IXMLDataParser<XMLData, Node>) {
        for (a in data.attributes.keys()) {
            if (processSpecificNamespace(a, node, data.attributes.get(a), data.attributesPos.get(a))) continue;
            if (isID(a)) {
                node.id = data.attributes.get(a);
                node.idSetted = true;
                if (!~/^[^\d\W]\w*$/.match(node.id))
                    Context.error('invalid id "${node.id}"', Context.makePosition(node.model.nodePos));
            } else {
                var n:Node = new Node();
                n.name = new XMLQName(a.name, node.name.ns);
                n.root = node.root;
                n.parent = node;
                n.superType = data.resolveType(n.name);
                n.cData = data.attributes.get(a);

                n.model = new XMLData();
                n.model.nodePos = data.attributesPos.get(a);
                n.model.name = n.name;
                n.model.cData = n.cData;

                node.unresolvedNodes.push(n);
            }
        }
    }

    function parseNodes(node:Node, data:XMLData, parser:IXMLDataParser<XMLData, Node>) {
        for (n in data.nodes) {
            var child = parser.parse(n, node);
            if (!processSpecificNamespace(child.name, node, child, child.model.nodePos)) node.unresolvedNodes.push(child);
        }
    }
}