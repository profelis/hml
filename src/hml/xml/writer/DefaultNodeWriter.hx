package hml.xml.writer;

import hml.xml.writer.base.StringNode;
import hml.base.MatchLevel;
import haxe.macro.Printer;
import hml.xml.writer.IHaxeWriter.IHaxeNodeWriter;
import hml.xml.Data;

import haxe.macro.Context;

using hml.base.MacroTools;
using haxe.macro.Tools;

class DefaultNodeWriter implements IHaxeNodeWriter<Node> {

	static var nodeIds:Map<String, Int> = new Map();

	public var printer:Printer = new Printer("");

	public function new() {}

	public function match(node:Node):MatchLevel {
		return GlobalLevel;
	}

	@:extern inline function writeNodePos(n:Node, method:Array<String>) {
		method.push('/* ${n.root.file}:${n.model.nodePos.from.line} characters: ${n.model.nodePos.from.pos}-${n.model.nodePos.to.pos} */');
	}

	function initNodeId(n:Node):Void {
        var name = n.name.name;
        name = name.charAt(0).toLowerCase() + name.substr(1);
        var key = n.root.file + name;
		if (n.id == null) {
			var i = nodeIds.exists(key) ? nodeIds[key] : 0;
            n.id =  '${name}__$i';
			nodeIds[key] = i + 1;
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
        if (!assign) Context.error("Node doesn't support childrens", Context.makePosition(child.model.nodePos));
		else method.push('${assign ? scope + " = " : ""}${getFieldName(child)}();');
	}

	function writeField(node:Node, method:Array<String>, writer:IHaxeWriter<Node>) {
		if (!node.oneInstance) {
  			method.push('if (${initedFieldName(node)}) return ${node.id};');
  			method.push('${initedFieldName(node)} = true;');

  			writer.fields.push(new FieldNodeWriter(node, null, null, initedFieldName(node), "Bool", "false"));
  			writer.fields.push(new FieldNodeWriter(node, node.meta, "@:isVar" + (node.publicAccess ? " public" : ""), '${node.id}(get, set)', nativeTypeString(node)));

  			var setter = ['${initedFieldName(node)} = true;', 'return ${node.id} = value;'];
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
    
    function assignOrBind(target:String, source:String, bindType:BindType):String {
        return if (bindType == null)
            '$target = $source;';
        else switch (bindType) {
            case BindType.SIMPLE_BIND:
                'bindx.BindExt.exprTo($source, $target);';
        }
    }

	public function writeAttribute(node:Node, scope:String, child:Node, writer:IHaxeWriter<Node>, method:Array<String>):Void {
		writeNodePos(child, method);
		if (child.cData != null) {
			method.push(assignOrBind('$scope.${child.name.name}', child.cData, child.bindType));
		}
        if (child.oneInstance && child.meta != null)
            Context.warning('unused meta', Context.makePosition(child.model.nodePos));
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