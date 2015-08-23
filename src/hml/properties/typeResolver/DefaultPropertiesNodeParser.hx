package hml.properties.typeResolver;

import hml.base.MatchLevel;
import hml.properties.typeResolver.IPropertiesParser.IPropertiesNodeParser;
import hml.properties.Data;

class DefaultPropertiesNodeParser implements IPropertiesNodeParser<PropertiesNodeData, PropertiesNodeType, PropertiesType> {
    public function new() {}

    public function match(data:PropertiesNodeData, parent:PropertiesType):MatchLevel {
        return MatchLevel.GlobalLevel;
    }

    public function parse(data:PropertiesNodeData, parent:PropertiesType):PropertiesNodeType {
        var res = new PropertiesNodeType();
        res.id = data.key;
        res.rawValue = data.value;
        return res;
    }
}
