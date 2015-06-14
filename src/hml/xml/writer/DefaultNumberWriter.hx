package hml.xml.writer;

import hml.base.MatchLevel;
import hml.xml.Data;

using hml.base.MacroTools;

class DefaultNumberWriter extends DefaultNodeWriter {

	override public function match(node:Node):MatchLevel {
		if (isChildOf(node, macro : Int)) return ClassLevel;
		if (isChildOf(node, macro : UInt)) return ClassLevel;
		if (isChildOf(node, macro : Float)) return ClassLevel;
		if (isChildOf(node, macro : Single)) return ClassLevel;

		return None;
	}

	override function writeFieldCtor(node:Node) {
		return node.cData != null ? node.cData : "0";
	}
}
