package hml.xml.writer;

import hml.base.MatchLevel;
import hml.xml.Data;

using hml.base.MacroTools;

class DefaultFloatWriter extends DefaultNodeWriter {

	override public function match(node:Node):MatchLevel {
		if (isChildOf(node, macro : Float)) return ClassLevel;

		return None;
	}

	override function writeFieldCtor(node:Node) {
		return node.cData != null ? node.cData : "0.0";
	}
}
