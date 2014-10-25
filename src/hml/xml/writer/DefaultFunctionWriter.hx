package hml.xml.writer;

import hml.base.MatchLevel;
import hml.xml.Data;

class DefaultFunctionWriter extends DefaultNodeWriter {
    override public function match(node:Node):MatchLevel {
        return switch (node.nativeType) {
            case TFun(_): ClassLevel;
            case _: None;
        }
    }

    override function writeFieldCtor(node:Node) {
        return node.cData;
    }
}