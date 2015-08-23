package hml.properties.reader;

import hml.base.MatchLevel;
import haxe.macro.Expr.Position;

interface IPropertiesReader<B> {
    public function match(data:String, fileName:String, pos:Position):MatchLevel;
    public function read(data:String, fileName:String, pos:Position):B;
}
