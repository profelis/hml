package hml.base;

import hml.base.Output;
import haxe.macro.Expr.Position;

typedef WriterResult = {
    var savedFiles:Array<String>;
}

interface IFileProcessor {
	public function match(path:String):MatchLevel;
	public function read(file:String, pos:Position, root:String):Void;
	public function write(output:Output):WriterResult;
}