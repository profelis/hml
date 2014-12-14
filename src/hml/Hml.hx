package hml;

import hml.base.IFileProcessor;
#if macro
import haxe.macro.Context;
import haxe.macro.Expr;

import hml.base.Output;

using sys.FileSystem;
using Reflect;
using StringTools;
using Lambda;

#end

class Hml {

	#if macro
	
	static var processedPaths:Map<String, Bool>;

	static var processors:Array<IFileProcessor> = [];

	#end

	macro static public function parse(output:Output, paths:Array<Expr>):Expr {
		if (processedPaths != null)
			Context.fatalError("call parse() method once", Context.currentPos());
		if (processors.length == 0)
			Context.fatalError("register file processors before parse()", Context.currentPos());

		var initState = initOutput(output);
		processedPaths = new Map();

		for (p in paths) {
			var path = switch (p.expr) {
				case EConst(CString(s)): s;
				case _: Context.error('parse method support only const string paths', p.pos);
			}
			if (!path.exists()) Context.error('"$path" expected', p.pos);
			if (!path.isDirectory()) Context.error('"$path" is not a directory', p.pos);
			process(path, p.pos, path);
		}
		
		var writeState = new Map<String, Bool>();
		for (p in processors) {
			var t = p.write(output);
			for (f in t.savedFiles) writeState.set(f, true);
		}
		
		cleanOutput(initState, writeState, output);

		return macro {};
	}

	#if macro
	static public function registerProcessor(processor:IFileProcessor):Void {
		processors.push(processor);
	}

	static function process(path:String, pos:Position, root:String):Void {
		if (processedPaths.exists(path)) return;
		processedPaths.set(path, true);

		if (path.isDirectory())
			for (p in readDir(path)) process('$path/$p', pos, root);
		else {
			var processor = processors.find(function (p) return p.supportFile(path));
			if (processor != null) {
				processor.read(path, pos, root);
			}
            #if hml_warn
			else Context.warning('Ignored', Context.makePosition({file:path, min:0, max:0}));
            #end
		}
	}

	static function initOutput(output:Output):Map<String, Bool> {
		var path = output.path;
		if (path.exists() && !path.isDirectory())
			Context.fatalError('output path "$path" already exist.', Context.currentPos());

		if (output.autoCreate != false && !path.exists())
			try {
				path.createDirectory();
			} catch (e:Dynamic) {
				Context.fatalError('can\'t create output folder "$path"', Context.currentPos());
			}

		if (!path.exists())
			Context.fatalError('output folder "$path" doesn\'t exist', Context.currentPos());

		output.allowOverride = output.allowOverride != false;
		
		var res = new Map<String, Bool>();
		function ls(path:String, root:String):Void {
			var p = '$root/$path';
			for (f in readDir(p)) {
				var fp = '$p/$f';
				if (fp.isDirectory()) {
					ls('$path/$f', root);
				}
				else if (fp.exists()) {
					var r = '$path/$f';
					if (r.startsWith("./")) r = r.substr(2);
					res.set(r, true);
				}
			}
		}
		ls(".", path);
		return res;
	}
	
	static function cleanOutput(initState:Map<String, Bool>, writeState:Map<String, Bool>, output:Output):Void {
		if (output.autoClear != false) {
			for (f in writeState.keys())
				initState.remove(f);
				
			for (f in initState.keys()) {
				var p = '${output.path}/$f';
				if (p.exists()) try {
					p.deleteFile();
				} catch (e:Dynamic) {
					Context.warning('Can\'t remove un-updated file "$p".', Context.currentPos());
				}
			}	
		}
		
		function rmEmptyFolders(path:String) {
			if (path.exists() && path.isDirectory()) {
				var files = readDir(path);
				if (files.length > 0) {
					for (f in files) rmEmptyFolders('$path/$f');
					files = readDir(path);
				}
				if (files.length == 0) {
					try {
						path.deleteDirectory();
					} catch (e:Dynamic) {
						Context.warning('Can\'t remove empty folder "$path".', Context.currentPos());
					}
				}	
			}
		}
		
		rmEmptyFolders(output.path);
	}
	
	static function readDir(path:String):Array<String> {
		return try {
			path.readDirectory();
		} catch (e:Dynamic) {
			Context.fatalError('Can\'t read directory "$path"', Context.currentPos());
		}
	}
	#end

}