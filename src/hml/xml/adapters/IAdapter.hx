package hml.xml.adapters;

import hml.xml.writer.IHaxeWriter;
import hml.xml.typeResolver.IHaxeTypeResolver;
import hml.xml.reader.IXMLParser.IXMLNodeParser;
import hml.xml.XMLProcessor.IXMLNodeParser;

interface IAdapter<B, N, T> {
    public function getXmlNodeParsers():Array<IXMLNodeParser<B>>;
    public function getXmlDataNodeParsers():Array<IXMLDataNodeParser<B, N, N>>;
    public function getTypeResolvers():Array<IHaxeTypeResolver<N, T>>;
    public function getNodeWriters():Array<IHaxeNodeWriter<N>>;
}
