package hml.xml.adapters;

import hml.xml.typeResolver.DefaultHaxeTypeResolver;
import hml.xml.typeResolver.DefaultXMLDataParser;
import hml.xml.typeResolver.DefaultXMLDataRootParser;
import hml.xml.writer.IHaxeWriter.IHaxeNodeWriter;
import hml.xml.typeResolver.IHaxeTypeResolver;
import hml.xml.reader.IXMLParser.IXMLNodeParser;
import hml.xml.XMLWriter.DefaultFunctionWriter;
import hml.xml.XMLWriter.DefaultStringWriter;
import hml.xml.XMLWriter.DefaultNodeWriter;
import hml.xml.XMLWriter.DefaultArrayWriter;
import hml.xml.XMLReader.DefaultXMLDocumentParser;
import hml.xml.XMLReader.DefaultXMLElementParser;
import hml.xml.Data;


class DefaultXMLAdapter implements IAdapter<XMLData, Node, Type> {
    public function new() {}

    public function getXmlNodeParsers():Array<IXMLNodeParser<XMLData>> {
        return [new DefaultXMLElementParser(), new DefaultXMLDocumentParser()];
    }
    public function getXmlDataNodeParsers():Array<IXMLDataNodeParser<XMLData, Node, Node>> {
        return [new DefaultXMLDataParser(), new DefaultXMLDataRootParser()];
    }
    public function getTypeResolvers():Array<IHaxeTypeResolver<Node, Type>> {
        return [new DefaultHaxeTypeResolver()];
    }
    public function getNodeWriters():Array<IHaxeNodeWriter<Node>> {
        return [new DefaultArrayWriter(), new DefaultNodeWriter(), new DefaultStringWriter(), new DefaultFunctionWriter()];
    }
}