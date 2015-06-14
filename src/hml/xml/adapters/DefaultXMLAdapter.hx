package hml.xml.adapters;

import hml.xml.writer.IHaxeWriter;
import hml.xml.reader.*;
import hml.xml.typeResolver.*;
import hml.xml.writer.*;
import hml.xml.typeResolver.IHaxeTypeResolver;
import hml.xml.reader.IXMLParser;
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
        return [
            new DefaultArrayWriter(),
            new DefaultNodeWriter(),
            new DefaultStringWriter(),
            new DefaultNumberWriter(),
            new DefaultBoolWriter(),
            new DefaultFunctionWriter()
        ];
    }
}