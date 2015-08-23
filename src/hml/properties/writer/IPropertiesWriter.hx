package hml.properties.writer;

import hml.base.MatchLevel;

class WriteNode<T> {
    public function toString():String { throw "override me"; }
    public var node:T;
}

interface IPropertiesNodeWriter<T> {
    public function match(node:T):MatchLevel;
    public function write(node:T, writer:IPropertiesWriter<T>):Void;
}

interface IPropertiesWriter<T> {
    public var fields:Array<WriteNode<T>>;
    public var methods:Array<WriteNode<T>>;
//    public var destroyMethod:Array<String>;
}
