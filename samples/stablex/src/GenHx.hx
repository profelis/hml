package ;

#if macro
import hml.base.MatchLevel;
import hml.xml.Data;
import hml.xml.XMLProcessor;

using haxe.macro.Context;
using haxe.macro.Tools;
#end

/**
 * ...
 * @author deep <system.grand@gmail.com>
 */

class GenHx {
	
	static function main() initHML();

	static macro function initHML() {
		hml.Hml.registerProcessor(new hml.xml.XMLProcessor([new StablexXMLAdapter(), new hml.xml.XMLProcessor.DefaultXMLAdapter()]));
		return macro hml.Hml.parse({path:"gen", autoCreate:true}, "ui");
	}
}
#if macro
class StablexXMLAdapter extends hml.xml.XMLProcessor.BaseXMLAdapter {
	override public function getNodeWriters():Array<IHaxeNodeWriter<Node>> return [new DefaultWidgetWriter(), new DefaultSkinWriter()];
	override public function getTypeResolvers():Array<IHaxeTypeResolver<Node, Type>> return [new StablexHaxeTypeResolver()];
}

class StablexHaxeTypeResolver implements hml.xml.XMLProcessor.IHaxeTypeResolver<Node, Type> {
	public function new() {}

	public var types:Map<String, Type>;
	public function getNativeType(node:Node):haxe.macro.Type return null;
	public function isType(node:Node):Bool return false;

	static public var EVENTS:Array<String> = ["click"];
	static public var MOUSE_EVENTS:Array<String> = ["click"];
	
	public function hasField(node:Node, qName:XMLQName):Bool {
		if (qName.ns != node.name.ns || EVENTS.indexOf(qName.name) == -1) return false;

		var type = node.nativeType;
		if (type == null) try {
			type = Context.getType(node.superType);
		} catch (e:Dynamic) { return false; }
		if (type == null) return false;

		if (hml.base.MacroTools.isChildOf(type, "ru.stablex.ui.widgets.Widget.Widget")) {
			var events = node.extra["events:" + qName.name];
			if (events == null) node.extra["events:" + qName.name] = events = [];
			events.push(qName);
			return true;
		}

		return false;
	}
	public function getFieldNativeType(node:Node, qName:XMLQName):haxe.macro.Type {
		var events:Array<XMLQName> = node.extra["events:" + qName.name];
		if (events != null && events.indexOf(qName) > -1) {
			if (MOUSE_EVENTS.indexOf(qName.name) > -1)
				return (macro : flash.events.MouseEvent -> Void).toType();

			return (macro : flash.events.Event -> Void).toType();
		}
		return null;
	}
}

class DefaultWidgetWriter extends hml.xml.XMLWriter.DefaultNodeWriter {
	override public function match(node:Node):MatchLevel return isChildOf(node, "ru.stablex.ui.widgets.Widget.Widget") ? ClassLevel : None;

	override function child(node:Node, scope:String, child:Node, method:Array<String>, assign = false) {
		method.push('$scope.addChild(${universalGet(child)});');
	}

	override function writeNodes(node:Node, scope:String, writer:IHaxeWriter<Node>, method:Array<String>) {
		for (a in node.nodes) {
			if (StablexHaxeTypeResolver.EVENTS.indexOf(a.name.name) > -1) {
				var events:Array<XMLQName> = node.extra["events:" + a.name.name];
				if (events != null && events.indexOf(a.name) > -1) {
					method.push('$scope.addEventListener("${a.name.name}", ${universalGet(a)});');
					switch (a.nativeType) {
						case TFun(t, ret):
							a.cData = 'function (event:${printer.printComplexType(t[0].t.toComplexType())}):' +
								'${printer.printComplexType(ret.toComplexType())} { ${a.cData}; }';
						case _:
					}
					
					writer.writeNode(a);
					continue;
				}
			}
			
			writer.writeAttribute(node, scope, a, method);
		}
		//super.writeNodes(node, scope, writer, method);
		method.push('$scope._onInitialize();');
	}

	override function postCtorInit(node, method) {
		method.push('this._onCreate();');
  	}

	override function postInit(node, method) {
		method.push('res._onCreate();');
  	}
}

class DefaultSkinWriter extends hml.xml.XMLWriter.DefaultNodeWriter {
	override public function match(node:Node):MatchLevel return isChildOf(node, "ru.stablex.ui.skins.Skin.Skin") ? ClassLevel : None;

	override function postCtorInit(node:Node, method:Array<String>) {
		// TODO: check Widget type inline
		method.push('if (Std.is(this, ru.stablex.ui.widgets.Widget)) {');
		method.push('    var w:ru.stablex.ui.widgets.Widget = cast this;');
		method.push('    ru.stablex.ui.UIBuilder.applyDefaults(w);');
		method.push('    w.onInitialize();');
		method.push('    w.onCreate();');
		method.push('}');
  	}

	override function postInit(node:Node, method:Array<String>) {
		// TODO: check Widget type inline
		method.push('if (Std.is(res, ru.stablex.ui.widgets.Widget)) {');
		method.push('    var w:ru.stablex.ui.widgets.Widget = cast res;');
		method.push('    ru.stablex.ui.UIBuilder.applyDefaults(w);');
		method.push('    w.onInitialize();');
		method.push('    w.onCreate();');
		method.push('}');
  	}
}
#end