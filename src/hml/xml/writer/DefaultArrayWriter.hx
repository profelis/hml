package hml.xml.writer;

import hml.base.MatchLevel;
import hml.xml.Data;

class DefaultArrayWriter extends DefaultNodeWriter {
    override public function match(node:Node):MatchLevel {
        return isChildOf(node, macro : Array) ? ClassLevel : None;
    }

    override function child(node:Node, scope:String, child:Node, method:Array<String>, assign = false) {
        method.push('$scope.push(${universalGet(child)});');
    }
}