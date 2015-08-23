package hml.properties.adapters;

import hml.properties.writer.DefaultPropertiesNodeWriter;
import hml.properties.writer.IPropertiesWriter.IPropertiesNodeWriter;
import hml.properties.typeResolver.DefaultPropertiesNodeParser;
import hml.properties.typeResolver.IPropertiesParser.IPropertiesNodeParser;
import hml.properties.Data;
import hml.properties.reader.IPropertiesReader;
import hml.properties.reader.DefaultPropertiesReader;

class DefaultPropertiesAdapter implements IPropertiesAdapter<PropertiesNodeData, PropertiesData, PropertiesNodeType, PropertiesType> {
    public function new() {
    }

    public function getReaders():Array<IPropertiesReader<PropertiesData>> {
        return [new DefaultPropertiesReader()];
    }

    public function getNodeParsers():Array<IPropertiesNodeParser<PropertiesNodeData, PropertiesNodeType, PropertiesType>> {
        return [new DefaultPropertiesNodeParser()];
    }

    public function getNodeWriters():Array<IPropertiesNodeWriter<PropertiesNodeType>> {
        return [new DefaultPropertiesNodeWriter()];
    }
}
