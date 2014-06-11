package hml.xml;

import haxe.macro.Printer;
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

class StringNode extends WriteNode<Node> {
	var str:String;

	public function new(node:Node, string:String) {
		this.node = node;
		this.str = string;
	}

	override public function toString():String return str;
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
		super(node, '${accessor != null ? accessor + " " : ""}function $id(${args != null ? args : ""})${type != null ? ":" + type : ""} {\n${b.toString()}}');
	}
}

class DefaultNodeWriter implements IHaxeNodeWriter<Node> {
	static var printer:Printer = new Printer("");
	public function new() {
	}

	public function match(node:Node):MatchLevel return GlobalLevel;

	@:expose inline function getFieldName(fieldName:String) return 'get_$fieldName';
	@:expose inline function setFieldName(fieldName:String) return 'set_$fieldName';
	@:expose inline function initedFieldName(fieldName:String) return '${fieldName}_initialized';

	@:expose inline function universalGet(node:Node) return node.oneInstance ? '${getFieldName(node.id)}()' : node.id;

	@:expose inline function nativeTypeString(node:Node) return printer.printComplexType(node.nativeType.toComplexType());

	@:expose inline function isChildOf(node:Node, type:String) {
		return hml.base.MacroTools.isChildOf(node.nativeType, type);
	}

	function writeNodes(node:Node, scope:String, writer:IHaxeWriter<Node>, method:Array<String>) {
		for (n in node.nodes) writer.writeAttribute(node, scope, n, method);
	}

	function writeChildren(node:Node, scope:String, writer:IHaxeWriter<Node>, method:Array<String>, assign = false) {
		for (n in node.children) {
  			writer.writeNode(n);
  			child(node, scope, n, method, assign);
  		}
	}

	function child(node:Node, scope:String, child:Node, method:Array<String>, assign = false) {
		method.push('${assign ? scope + " = " : ""}${getFieldName(child.id)}();');
	}

	function writeField(node:Node, method:Array<String>, writer:IHaxeWriter<Node>) {
		if (!node.oneInstance) {
  			method.push('if (${initedFieldName(node.id)}) return ${node.id};');
  			method.push('${initedFieldName(node.id)} = true;');

  			writer.fields.push(new FieldNodeWriter(node, null, initedFieldName(node.id), "Bool", "false"));
  			writer.fields.push(new FieldNodeWriter(node, "@:isVar public", '${node.id}(get, set)', nativeTypeString(node)));

  			var setter = ['return ${node.id} = value;'];
  			writer.methods.push(new MethodNodeWriter(node, null, setFieldName(node.id), 'value:${nativeTypeString(node)}', nativeTypeString(node), setter));
  		}
	}

	@:expose inline function defaultWrite(node:Node, scope:String, writer:IHaxeWriter<Node>, method:Array<String>, assign = false) {
		writeNodes(node, scope, writer, method);
  		writeChildren(node, scope, writer, method, assign);
	}

	public function writeAttribute(node:Node, scope:String, child:Node, writer:IHaxeWriter<Node>, method:Array<String>):Void {
		if (child.cData != null) {
			method.push('$scope.${child.name.name} = ${child.cData};');	
		}
		defaultWrite(child, '$scope.${child.name.name}', writer, method, true);
	}

  	public function write(node:Node, writer:IHaxeWriter<Node>):Void {
  		var method = [];
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
			writer.methods.push(new MethodNodeWriter(node, node.oneInstance ? "@:expose inline" : null, getFieldName(node.id), null, nativeTypeString(node), method));
		}
  	}

	function predCtorInit(node, method) {}
	function postCtorInit(node, method) {}

	function predInit(node, method) {}
  	function postInit(node, method) {}

  	function writeFieldCtor(node:Node) return 'new ${nativeTypeString(node)}()';
}

class DefaultStringWriter extends DefaultNodeWriter {
	override public function match(node:Node):MatchLevel return isChildOf(node, "String.String") ? ClassLevel : None;

	override function writeFieldCtor(node:Node) return node.cData;

	override public function writeAttribute(node:Node, scope:String, child:Node, writer:IHaxeWriter<Node>, method:Array<String>):Void {
		writer.writeNode(child);
		method.push('$scope.${child.name.name} = ${universalGet(child)};');
	}
}

class DefaultFunctionWriter extends DefaultNodeWriter {
	override public function match(node:Node):MatchLevel return switch (node.nativeType) {
		case TFun(_): ClassLevel;
		case _: None;
	};

	override function writeFieldCtor(node:Node) return node.cData;
}

class DefaultArrayWriter extends DefaultNodeWriter {
	override public function match(node:Node):MatchLevel return isChildOf(node, "Array.Array") ? ClassLevel : None;

	override function child(node:Node, scope:String, child:Node, method:Array<String>, assign = false) method.push('$scope.push(${universalGet(child)});');
}

class DefaultSpriteWriter extends DefaultNodeWriter {
	
	override public function match(node:Node):MatchLevel return isChildOf(node, "flash.display.DisplayObject.DisplayObject") ? ModuleLevel : None;

	override function child(node:Node, scope:String, child:Node, method:Array<String>, assign = false) method.push('$scope.addChild(${universalGet(child)});');
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
			res += 'class $name extends ${type.superType} {\n';
			inline function writeNode(f:WriteNode<Dynamic>) {
				var s = f.toString();
				s = '\n${TAB}${s.split("\n").join("\n" + TAB)}\n';
				res += s;
			}
			for (f in fields) writeNode(f);
			for (f in methods) writeNode(f);
			res += '}';

			var path = '${output.path}/${type.type.replace(".", "/")}';
			var p = new Path(path);
			if (p.dir != null) p.dir.createDirectory();
			p.ext = "hx";
			sys.io.File.saveContent(p.toString(), res.toString());
		}
	}

	public var fields:Array<WriteNode<Node>>;
	public var methods:Array<WriteNode<Node>>;

	public function writeNode(node:Node):Void {
		var writer = writers.findMatch(function (p) return p.match(node));
		return writer.write(node, this);
	}

	public function writeAttribute(node:Node, scope:String, child:Node, method:Array<String>):Void {
		var writer = writers.findMatch(function (p) return p.match(child));
		writer.writeAttribute(node, scope, child, this, method);
	}
}