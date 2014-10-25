package hml.xml.adapters.base;

import hml.xml.writer.IHaxeWriter;
import hml.xml.typeResolver.IHaxeTypeResolver;
import hml.xml.reader.IXMLParser;
import hml.xml.Data;

class BaseXMLAdapter implements IAdapter<XMLData, Node, Type> {
    public function new() {}

    public function getXmlNodeParsers():Array<IXMLNodeParser<XMLData>> return null;
    public function getXmlDataNodeParsers():Array<IXMLDataNodeParser<XMLData, Node, Node>> return null;
    public function getTypeResolvers():Array<IHaxeTypeResolver<Node, Type>> return null;
    public function getNodeWriters():Array<IHaxeNodeWriter<Node>> return null;
}