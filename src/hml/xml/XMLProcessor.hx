package hml.xml;

import hml.base.MatchLevel;
import hml.xml.adapters.base.MergedAdapter;
import hml.xml.adapters.IAdapter;
import hml.base.BaseFileProcessor;
import hml.xml.Data;
import hml.xml.TypeResolver;
import hml.xml.XMLReader;
import hml.xml.XMLWriter;

using hml.base.MatchLevel;


class XMLProcessor extends BaseFileProcessor<XMLDataRoot, Type> {

	static var XML_EXT = ~/.xml$/;

	public function new(adapters:Array<IAdapter<XMLData, Node, Type>>) {
		var merged = new MergedAdapter<XMLData, Node, Type>(adapters);
		super(
			new XMLReader(merged.getXmlNodeParsers()), 
			new TypeResolver(merged.getXmlDataNodeParsers(), merged.getTypeResolvers()), 
			new XMLWriter(merged.getNodeWriters())
		);
	}

	override public function match(file:String):MatchLevel {
		return XML_EXT.match(file) ? GlobalLevel : None;
	}
}