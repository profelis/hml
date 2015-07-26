package hml.xml.writer.base;

import hml.base.Strings;
import hml.xml.writer.IHaxeWriter.WriteNode;
import hml.xml.Data;

class StringNode extends WriteNode<Node> {
    var str:String;

    public function new(node:Node, string:String) {
        this.node = node;
        this.str = string;
    }

    override public function toString():String {
        return str;
    }

    inline static public function ifCond(node:Node, str:String) {
        return '${node.ifCond.length > 0 ? "#if (" + node.ifCond.join(") && (") + ") " : ""}${str}${node.ifCond.length > 0 ? " #end": ""}';
    }
}

class FieldNodeWriter extends StringNode {
    public function new(node:Node, meta:String, accessor:String, id:String, ?type:String, ?value:String) {
        super(node, StringNode.ifCond(node, '${meta != null ? meta + "\n" : ""}${accessor != null ? accessor + " " : ""}var $id${type != null ? ":" + type : ""}${value != null ? " = " + value : ""};'));
    }
}

class MethodNodeWriter extends StringNode {
    public function new(node:Node, accessor:String, id:String, args:String, type:String, body:Array<String>) {
        var b = new Strings();
        for (s in body) b += '${XMLWriter.TAB}$s\n';
        super(node, StringNode.ifCond(node, '${accessor != null ? accessor + " " : ""}function $id(${args != null ? args : ""})${type != null ? ":" + type : ""} {\n$b}'));
    }
}