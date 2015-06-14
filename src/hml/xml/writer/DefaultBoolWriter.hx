package hml.xml.writer;

import hml.base.MatchLevel;
import hml.xml.Data;

using hml.base.MacroTools;

class DefaultBoolWriter extends DefaultNodeWriter {

	override public function match(node:Node):MatchLevel {
		return (isChildOf(node, macro : Bool)) ? ClassLevel : None;
	}

	override function writeFieldCtor(node:Node) {
		return node.cData != null ? node.cData : "false";
	}
}