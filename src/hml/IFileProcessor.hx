package hml;

import hml.Hml.Output;
import haxe.macro.Expr.Position;

interface IFileProcessor {
	public function supportFile(path:String):Bool;
	public function read(file:String, pos:Position):Void;
	public function write(output:Output):Void;
}