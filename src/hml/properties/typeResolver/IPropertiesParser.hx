package hml.properties.typeResolver;

import hml.base.MatchLevel;

interface IPropertiesParser<B, T> {
    public function parse(data:B):T;
}

interface IPropertiesNodeParser<B, NT, T> {
    public function match(data:B, parent:T):MatchLevel;
    public function parse(data:B, parent:T):NT;
}