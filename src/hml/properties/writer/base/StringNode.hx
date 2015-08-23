package hml.properties.writer.base;

import hml.properties.writer.IPropertiesWriter.WriteNode;
import hml.base.Strings;
import hml.properties.Data;

class StringNode extends WriteNode<PropertiesNodeType> {
    var str:String;

    public function new(node:PropertiesNodeType, string:String) {
        this.node = node;
        this.str = string;
    }

    override public function toString():String {
        return str;
    }
}

class FieldNodeWriter extends StringNode {
    public function new(node:PropertiesNodeType, accessor:String, ?type:String, ?value:String) {
        super(node, '${accessor != null ? accessor + " " : ""}var ${node.id}${type != null ? ":" + type : ""}${value != null ? " = " + value : ""};');
    }
}
