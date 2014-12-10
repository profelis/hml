package hml.xml.writer;
import hml.base.MatchLevel;

class WriteNode<T> {
    public function toString():String { throw "override me"; }
    public var node:T;
}

interface IHaxeNodeWriter<T> {
    public function match(node:T):MatchLevel;
    public function write(node:T, writer:IHaxeWriter<T>):Void;
    public function writeAttribute(node:T, scope:String, child:T, writer:IHaxeWriter<T>, method:Array<String>):Void;
}

interface IHaxeWriter<T> {
    public var fields:Array<WriteNode<T>>;
    public var methods:Array<WriteNode<T>>;
    public var destroyMethod:Array<String>;
    public function writeNode(node:T):Void;
    public function writeAttribute(node:T, scope:String, child:T, method:Array<String>):Void;
}