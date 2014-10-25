package hml.base.fileProcessor;
import haxe.macro.Expr.Position;

interface IReader<B> {
    public function read(file:String, pos:Position, root:String):B;
}