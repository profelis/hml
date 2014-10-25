package hml.xml;

import haxe.macro.Printer;
import haxe.macro.Context;
import hml.base.BaseFileProcessor.IWriter;
import hml.base.Strings;
import hml.Hml.Output;
import haxe.io.Path;
import hml.xml.Data;
import hml.base.MatchLevel;
import hml.xml.XMLProcessor;

using haxe.macro.Tools;
using hml.base.MatchLevel;
using sys.FileSystem;
using StringTools;
using Lambda;
using haxe.macro.Printer;
using haxe.macro.Context;
using hml.base.MacroTools;

class StringNode extends WriteNode<Node> {
	var str:String;

	public function new(node:Node, string:String) {
		this.node = node;
		this.str = string;
	}

	override public function toString():String {
		return str;
	}
}

class FieldNodeWriter extends StringNode {
	public function new(node:Node, accessor:String, id:String, ?type:String, ?value:String) {
		super(node, '${accessor != null ? accessor + " " : ""}var $id${type != null ? ":" + type : ""}${value != null ? " = " + value : ""};');
	}
}

class MethodNodeWriter extends StringNode {
	public function new(node:Node, accessor:String, id:String, args:String, type:String, body:Array<String>) {
		var b = new Strings();
		for (s in body) b += '${XMLWriter.TAB}$s\n';
		super(node, '${accessor != null ? accessor + " " : ""}function $id(${args != null ? args : ""})${type != null ? ":" + type : ""} {\n$b}');
	}
}

class DefaultNodeWriter implements IHaxeNodeWriter<Node> {
	
	static var nodeIds:Map<Node, Int> = new Map();

	public var printer:Printer = new Printer("");

	public function new() {}

	public function match(node:Node):MatchLevel {
		return GlobalLevel;
	}

	@:extern inline function writeNodePos(n:Node, method:Array<String>) {
		method.push('/* ${n.root.file}:${n.model.nodePos.from.line} characters: ${n.model.nodePos.from.pos}-${n.model.nodePos.to.pos} */');
	}

	function initNodeId(n:Node):Void {
		if (n.id == null) {
			var i = nodeIds.exists(n.root) ? nodeIds.get(n.root) : 0;
			n.id = "field" + (i++);
			nodeIds[n.root] = i;
		}
	}

	@:extern public inline function getFieldName(node:Node):String {
		initNodeId(node);
		return 'get_${node.id}';
	}

	@:extern public inline function setFieldName(node:Node):String {
		initNodeId(node);
		return 'set_${node.id}';
	}

	@:extern public inline function initedFieldName(node:Node):String {
		initNodeId(node);
		return '${node.id}_initialized';
	}

	@:extern public inline function universalGet(node:Node) {
		return node.oneInstance ? '${getFieldName(node)}()' : node.id;
	}

	@:extern public inline function nativeTypeString(node:Node) {
		return if (node.superType != null)
			'${node.superType}${node.generic != null ? "<" + node.generic.typesToString() + ">" : ""}' 
			else printer.printComplexType(node.nativeType.toComplexType()) + (node.generic != null ? '<${node.generic.typesToString()}>' : "");
	}

	@:extern public inline function isChildOf(node:Node, type:haxe.macro.Expr.ComplexType) {
		return node.nativeType != null ? node.nativeType.isChildOf(type) : false;
	}

	function writeNodes(node:Node, scope:String, writer:IHaxeWriter<Node>, method:Array<String>) {
		for (n in node.nodes) writer.writeAttribute(node, scope, n, method);
	}

    function writeDeclarations(node:Type, scope:String, writer:IHaxeWriter<Node>, method:Array<String>) {
        for (n in node.declarations) writer.writeNode(n);
    }

	function writeChildren(node:Node, scope:String, writer:IHaxeWriter<Node>, method:Array<String>, assign = false) {
		for (n in node.children) {
  			writer.writeNode(n);
  			child(node, scope, n, method, assign);
  		}
	}

	function child(node:Node, scope:String, child:Node, method:Array<String>, assign = false) {
		method.push('${assign ? scope + " = " : ""}${getFieldName(child)}();');
	}

	function writeField(node:Node, method:Array<String>, writer:IHaxeWriter<Node>) {
		if (!node.oneInstance) {
  			method.push('if (${initedFieldName(node)}) return ${node.id};');
  			method.push('${initedFieldName(node)} = true;');

  			writer.fields.push(new FieldNodeWriter(node, null, initedFieldName(node), "Bool", "false"));
  			writer.fields.push(new FieldNodeWriter(node, "@:isVar public", '${node.id}(get, set)', nativeTypeString(node)));

  			var setter = ['return ${node.id} = value;'];
  			writer.methods.push(new MethodNodeWriter(node, null, setFieldName(node), 'value:${nativeTypeString(node)}', nativeTypeString(node), setter));
  		}
	}

	@:extern inline function defaultWrite(node:Node, scope:String, writer:IHaxeWriter<Node>, method:Array<String>, assign = false) {
        if (Std.is(node, Type)) {
            writeDeclarations(cast node, scope, writer, method);
        }
		writeNodes(node, scope, writer, method);
  		writeChildren(node, scope, writer, method, assign);
	}

	public function writeAttribute(node:Node, scope:String, child:Node, writer:IHaxeWriter<Node>, method:Array<String>):Void {
		writeNodePos(child, method);
		if (child.cData != null) {
			method.push('$scope.${child.name.name} = ${child.cData};');
		}
		defaultWrite(child, '$scope.${child.name.name}', writer, method, true);
	}

  	public function write(node:Node, writer:IHaxeWriter<Node>):Void {
  		var method = [];
  		writeNodePos(node, method);
  		if (Std.is(node, Type)) {
  			method.push('super();');
  			predCtorInit(node, method);
  			defaultWrite(node, "this", writer, method);
  			postCtorInit(node, method);
	  		writer.methods.push(new MethodNodeWriter(node, "public", 'new', null, null, method));
  		} else {
			writeField(node, method, writer);
	  		method.push('var res = ${writeFieldCtor(node)};');
	  		if (!node.oneInstance) method.push('this.${node.id} = res;');
	  		predInit(node, method);
			defaultWrite(node, "res", writer, method);
			postInit(node, method);
			method.push('return res;');
			writer.methods.push(new MethodNodeWriter(node, node.oneInstance ? "inline" : null, getFieldName(node), null, nativeTypeString(node), method));
		}
  	}

	function predCtorInit(node, method) {}
	function postCtorInit(node, method) {}

	function predInit(node, method) {}
  	function postInit(node, method) {}

  	function writeFieldCtor(node:Node) {
  		return 'new ${nativeTypeString(node)}()';
  	}
}

class DefaultStringWriter extends DefaultNodeWriter {
	override public function match(node:Node):MatchLevel {
		return isChildOf(node, macro : String) ? ClassLevel : None;
	}

	override public function writeAttribute(node:Node, scope:String, child:Node, writer:IHaxeWriter<Node>, method:Array<String>):Void {
		writeNodePos(child, method);
		if (child.oneInstance && child.children.length > 0 || child.nodes.length > 0) {
			writer.writeNode(child);
			method.push('$scope.${child.name.name} = ${universalGet(child)};');
		} else {
			method.push('$scope.${child.name.name} = ${child.cData};');
		}
	}

	override function writeFieldCtor(node:Node) {
		return node.cData != null ? node.cData : '""';
	}
}

class DefaultFunctionWriter extends DefaultNodeWriter {
	override public function match(node:Node):MatchLevel {
		return switch (node.nativeType) {
			case TFun(_): ClassLevel;
			case _: None;
		}
	}

	override function writeFieldCtor(node:Node) {
		return node.cData;
	}
}

class DefaultArrayWriter extends DefaultNodeWriter {
	override public function match(node:Node):MatchLevel {
		return isChildOf(node, macro : Array) ? ClassLevel : None;
	}

	override function child(node:Node, scope:String, child:Node, method:Array<String>, assign = false) {
		method.push('$scope.push(${universalGet(child)});');
	}
}

class XMLWriter implements IWriter<Type> implements IHaxeWriter<Node> {

	public static inline var TAB = "    ";

	public function new(writers:Array<IHaxeNodeWriter<Node>>) {
		this.writers = writers;
	}

	var writers:Array<IHaxeNodeWriter<Node>>;

	var output:Output;

	public function write(types:Array<Type>, output:Output):Void {
		this.output = output;

		for (type in types) {
			fields = [];
			methods = [];

			writeNode(type);

			var res = new Strings();

			var pos = type.type.lastIndexOf(".");
			var pack = pos > -1 ? type.type.substr(0, pos) : "";
			var name = pos > -1 ? type.type.substr(pos + 1) : type.type;
			res += 'package $pack;\n';
			res += '\n';
			res += 'class $name extends ${type.superType}';
			if (type.implementsList != null) {
				for (i in type.implementsList)
					res += ' implements ${[i].typesToString()}';
			}
			res += ' {\n';
			inline function writeNode(f:WriteNode<Dynamic>) {
				var s = f.toString();
				s = '\n${TAB}${s.split("\n").join("\n" + TAB)}\n';
				res += s;
			}
			for (f in fields) writeNode(f);
			for (f in methods) writeNode(f);
			res += '}\n';

			var path = '${output.path}/${type.type.replace(".", "/")}';
			var p = new Path(path);
			if (p.dir != null) p.dir.createDirectory();
			p.ext = "hx";
			sys.io.File.saveContent(p.toString(), res);
		}
	}

	public var fields:Array<WriteNode<Node>>;
	public var methods:Array<WriteNode<Node>>;

	public function writeNode(node:Node):Void {
		var writer;
        #if hml_debug
        writer = writers.findMatch(function (p) return p.match(node));
        #else
		try {
			writer = writers.findMatch(function (p) return p.match(node));
		} catch (e:Dynamic) {
			Context.error(e, Context.makePosition(node.model.nodePos));
		}
        #end
		return writer.write(node, this);
	}

	public function writeAttribute(node:Node, scope:String, child:Node, method:Array<String>):Void {
		var writer;
        #if hml_debug
        trace(child);
        writer = writers.findMatch(function (p) return p.match(child));
        #else
		try {
			writer = writers.findMatch(function (p) return p.match(child));
		} catch(e:Dynamic) {
			Context.error(e, Context.makePosition(child.model.nodePos));
		}
        #end
		writer.writeAttribute(node, scope, child, this, method);
	}
}