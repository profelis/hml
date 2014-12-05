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
            method.push(assignOrBind('$scope.${child.name.name}', universalGet(child), child.bindType));
        } else {
            method.push(assignOrBind('$scope.${child.name.name}', child.cData, child.bindType));
        }
    }

    override function writeFieldCtor(node:Node) {
        return node.cData != null ? node.cData : '""';
    }
}