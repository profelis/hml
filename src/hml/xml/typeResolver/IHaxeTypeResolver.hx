package hml.xml.typeResolver;

import hml.base.MatchLevel;
import hml.xml.Data;

interface IXMLDataParser<B, T> {
    public function parse(data:B, parent:T):T;
}

interface IXMLDataNodeParser<B, T, R> {
    public function match(data:B, parent:T):MatchLevel;
    public function parse(data:B, parent:T, parser:IXMLDataParser<B, T>):R;
}

interface IHaxeTypeResolver<N, T> {
    public var types:Map<String, T>;
    public function getNativeType(node:N):haxe.macro.Type;
    public function isType(node:N):Bool;
    public function getFieldNativeType(node:N, qName:XMLQName):Null<haxe.macro.Type>;
}
