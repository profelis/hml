package hml.xml.writer;

import hml.base.MatchLevel;
import hml.xml.Data;

class DefaultStringWriter extends DefaultNodeWriter {
    override public function match(node:Node):MatchLevel {
        return isChildOf(node, macro : String) ? ClassLevel : None;
    }

    override public function writeAttribute(node:Node, scope:String, child:Node, writer:IHaxeWriter<Node>, method:Array<String>):Void {
        writeNodePos(child, method);
        if (child.oneInstance && child.children.length > 0 || child.nodes.length > 0) {
            writer.writeNode(child);
            method.push(assignOrBind(node, scope, child, universalGet(child), writer));
        } else {
            method.push(assignOrBind(node, scope, child, child.cData, writer));
        }
    }

    override function writeFieldCtor(node:Node) {
        return node.cData != null ? node.cData : '""';
    }
}