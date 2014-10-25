package hml.base;

import hml.IFileProcessor;
import haxe.macro.Expr.Position;
import hml.Hml.Output;

interface IReader<B> {
	public function read(file:String, pos:Position, root:String):B;
}

interface ITypeResolver<B, T> {
	public function resolve(data:Array<B>):Array<T>;
}

interface IWriter<T> {
	public function write(types:Array<T>, output:Output):Void;
}

class BaseFileProcessor<B, T> implements IFileProcessor {

	var reader:IReader<B>;
	var resolver:ITypeResolver<B, T>;
	var writer:IWriter<T>;

	public function new(reader:IReader<B>, resolver:ITypeResolver<B, T>, writer:IWriter<T>) {
		this.reader = reader;
		this.resolver = resolver;
		this.writer = writer;
	}

	var data:Array<B> = [];

	public function supportFile(path:String):Bool {
		throw "override me";
	}

	public function read(file:String, pos:Position, root:String):Void {
		data.push(reader.read(file, pos, root));
	}
	public function write(output:Output):Void {
		var types = resolver.resolve(data);
		writer.write(types, output);
	}

}