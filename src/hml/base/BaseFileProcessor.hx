package hml.base;

import hml.base.fileProcessor.IWriter;
import hml.base.fileProcessor.ITypeResolver;
import hml.base.fileProcessor.IReader;
import hml.base.IFileProcessor;
import haxe.macro.Expr.Position;
import hml.base.Output;

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
	public function write(output:Output):WriterResult {
		var types = resolver.resolve(data);
		return writer.write(types, output);
	}

}