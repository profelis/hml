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
}

class FieldNodeWriter extends StringNode {
    public function new(node:Node, accessor:String, id:String, ?type:String, ?value:String) {
        super(node, '${accessor != null ? accessor + " " : ""}var $id${type != null ? ":" + type : ""}${value != null ? " = " + value : ""};');
    }
}

class MethodNodeWriter extends StringNode {
    public function new(node:Node, accessor:String, id:String, args:String, type:String, body:Array<String>) {
        var b = new Strings();
        for (s in body) b += '${XMLWriter.TAB}$s\n';
        super(node, '${accessor != null ? accessor + " " : ""}function $id(${args != null ? args : ""})${type != null ? ":" + type : ""} {\n$b}');
    }
}