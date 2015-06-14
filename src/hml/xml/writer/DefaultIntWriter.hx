package hml.xml.writer;

import hml.base.MatchLevel;
import hml.xml.Data;

using hml.base.MacroTools;

class DefaultIntWriter extends DefaultNodeWriter {

	override public function match(node:Node):MatchLevel {
		if (isChildOf(node, macro : Int)
			|| isChildOf(node, macro : UInt)
			|| isChildOf(node, macro : Single)) return CustomLevel(ClassLevel, 1);

		return None;
	}

	override function writeFieldCtor(node:Node) {
		return node.cData != null ? node.cData : "0";
	}
}
