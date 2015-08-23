package hml.properties;

import hml.base.BaseFileProcessor;
import hml.base.MatchLevel;

import hml.properties.Data;
import hml.properties.adapters.IPropertiesAdapter;
import hml.properties.adapters.base.MergedAdapter;
import hml.properties.TypeResolver;

using hml.base.MatchLevel;


class PropertiesProcessor extends BaseFileProcessor<PropertiesData, PropertiesType> {

    static var PROPERTIES_EXT = ~/.properties$/;

    public function new(adapters:Array<IPropertiesAdapter<PropertiesNodeData, PropertiesData, PropertiesNodeType, PropertiesType>>) {
        var merged = new MergedAdapter<PropertiesNodeData, PropertiesData, PropertiesNodeType, PropertiesType>(adapters);
        super(
            new PropertiesReader(merged.getReaders()),
            new TypeResolver(merged.getNodeParsers()),
            new PropertiesWriter(merged.getNodeWriters())
        );
    }

    override public function match(file:String):MatchLevel {
        return PROPERTIES_EXT.match(file) ? GlobalLevel : None;
    }
}