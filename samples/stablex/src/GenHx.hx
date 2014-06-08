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
}

class DefaultWidgetWriter extends hml.xml.XMLWriter.DefaultNodeWriter {
	override public function match(node:Node):MatchLevel return isChildOf(node, "ru.stablex.ui.widgets.Widget.Widget") ? ClassLevel : None;

	override function child(node:Node, scope:String, child:Node, method:Array<String>, assign = false) {
		method.push('$scope.addChild(${universalGet(child)});');
	}

	override function postCtorInit(node, method) {
		method.push('this.onInitialize();');
		method.push('this.onCreate();');
  	}

	override function postInit(node, method) {
		method.push('res.onInitialize();');
		method.push('res.onCreate();');
  	}
}

class DefaultSkinWriter extends hml.xml.XMLWriter.DefaultNodeWriter {
	override public function match(node:Node):MatchLevel return isChildOf(node, "ru.stablex.ui.skins.Skin.Skin") ? ClassLevel : None;

	override function postCtorInit(node, method) {
		method.push('if (Std.is(this, ru.stablex.ui.widgets.Widget)) {');
		method.push('    var w:ru.stablex.ui.widgets.Widget = cast this;');
		method.push('    ru.stablex.ui.UIBuilder.applyDefaults(w);');
		method.push('    w.onInitialize();');
		method.push('    w.onCreate();');
		method.push('}');
  	}

	override function postInit(node, method) {
		method.push('if (Std.is(res, ru.stablex.ui.widgets.Widget)) {');
		method.push('    var w:ru.stablex.ui.widgets.Widget = cast res;');
		method.push('    ru.stablex.ui.UIBuilder.applyDefaults(w);');
		method.push('    w.onInitialize();');
		method.push('    w.onCreate();');
		method.push('}');
  	}
}
#end