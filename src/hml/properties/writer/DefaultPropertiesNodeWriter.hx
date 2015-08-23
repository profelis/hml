package hml.properties.writer;

import hml.properties.Data;
import hml.properties.writer.base.StringNode.FieldNodeWriter;
import hml.base.MatchLevel;
import hml.properties.writer.IPropertiesWriter.IPropertiesNodeWriter;

class DefaultPropertiesNodeWriter implements IPropertiesNodeWriter<PropertiesNodeType> {
    public function new() {
    }

    public function match(node:PropertiesNodeType):MatchLevel {
        return MatchLevel.GlobalLevel;
    }

    public function write(node:PropertiesNodeType, writer:IPropertiesWriter<PropertiesNodeType>):Void {
        writer.fields.push(new FieldNodeWriter(node, "public", "String", '"${node.rawValue}"'));
    }
}