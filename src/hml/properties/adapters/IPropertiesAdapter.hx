package hml.properties.adapters;

import hml.properties.writer.IPropertiesWriter.IPropertiesNodeWriter;
import hml.properties.typeResolver.IPropertiesParser.IPropertiesNodeParser;
import hml.properties.reader.IPropertiesReader;

interface IPropertiesAdapter<NB, B, NT, T> {

    public function getReaders():Array<IPropertiesReader<B>>;
    public function getNodeParsers():Array<IPropertiesNodeParser<NB, NT, T>>;
    public function getNodeWriters():Array<IPropertiesNodeWriter<NT>>;
}
