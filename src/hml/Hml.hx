package hml;

#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

using sys.FileSystem;
using Reflect;
using StringTools;
using Lambda;

#end

typedef Output = {
	path:String,
	?autoClear:Bool, // empty output folder before generate output: default true
	?autoCreate:Bool, // create output folder if expected: default true
	?allowOverride:Bool // allow override files in output folder: default false
}

class Hml {

	macro static public function parse(output:Output, paths:Array<Expr>):Expr {
		if (processedPaths != null)
			Context.fatalError("call parse once", Context.currentPos());
		if (processors.length == 0)
			Context.fatalError("register file processors first", Context.currentPos());

		initOutput(output);
		processedPaths = new Map();

		for (p in paths) {
			var path = switch (p.expr) {
				case EConst(CString(s)): s;
				case _: Context.error('parse method support only const string args', p.pos);
			}
			if (!path.exists()) Context.error('"$path" expected', p.pos);
			if (!path.isDirectory()) Context.error('"$path" is not directory', p.pos);
			process(path, p.pos);
		}

		for (p in processors) p.write(output);

		return macro {};
	}

	#if macro
	static public function registerProcessor(processor:IFileProcessor):Void {
		processors.push(processor);
	}

	static var processedPaths:Map<String, Bool>;

	static var processors:Array<IFileProcessor> = [];

	static function process(path:String, pos:Position):Void {
		if (processedPaths.exists(path)) return;
		processedPaths.set(path, true);

		if (path.isDirectory()) {
			for (p in path.readDirectory()) process('$path/$p', pos);
		} else {
			var processor = processors.find(function (p) return p.supportFile(path));
			if (processor != null) processor.read(path, pos); else trace('>> ignore $path');
		}
	}

	static function initOutput(output:Output):Void {
		var path = output.path;
		if (path.exists() && !path.isDirectory())
			Context.fatalError('output folder "$path" already exist and it is not directory', Context.currentPos());

		if (output.autoClear != false && path.exists()) rmDir(path);
		if (output.autoCreate != false && !path.exists()) {
			try {
				path.createDirectory();
			} catch (e:Dynamic) {
				Context.fatalError('can\'t create output folder "$path"', Context.currentPos());
			}
		}

		if (!path.exists())
			Context.fatalError('output folder "$path" doesn\'t exist.', Context.currentPos());
		if (output.allowOverride != true && path.readDirectory().length > 0)
			Context.fatalError('output folder "$path" is not empty.', Context.currentPos());	
	}

	static function rmDir(path:String) {
		if (!path.exists()) return;
		if (path.isDirectory()) {
			for (p in path.readDirectory()) rmDir('$path/$p');
			path.deleteDirectory();
		}
		else path.deleteFile();
	}
	#end

}