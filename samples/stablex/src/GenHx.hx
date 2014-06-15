package ;

#if macro
import hml.base.MatchLevel;
import hml.xml.Data;
import hml.xml.XMLProcessor;

import hml.xml.adapters.FlashAdapter;
import hml.xml.adapters.BaseMetaAdapter;

using haxe.macro.Context;
using haxe.macro.Tools;

using StringTools;
#end

/**
 * ...
 * @author deep <system.grand@gmail.com>
 */

class GenHx {
	static function main() initHML();

	static macro function initHML() {
		hml.Hml.registerProcessor(new hml.xml.XMLProcessor([new StablexXMLAdapter(), new FlashAdapter(), new hml.xml.XMLProcessor.DefaultXMLAdapter()]));
		return macro hml.Hml.parse({path:"gen", autoCreate:true}, "ui");
	}
}
#if macro
class StablexXMLAdapter extends FlashAdapter {
	public function new() {
		var eventType = (macro : flash.events.Event -> Void).toType();
		var widgetEvent = (macro : ru.stablex.ui.events.WidgetEvent -> Void).toType();
		var dndEvent = (macro : ru.stablex.ui.events.DndEvent -> Void).toType();
		var scrollEvent = (macro : ru.stablex.ui.events.ScrollEvent -> Void).toType();

		var events:Map<String, EventMetaData> = new Map();
		events.set('display', new EventMetaData(eventType, macro flash.events.Event.ADDED_TO_STAGE));

		events.set('widgetCreate', new EventMetaData(widgetEvent, macro ru.stablex.ui.events.WidgetEvent.CREATE));
		events.set('widgetFree', new EventMetaData(widgetEvent, macro ru.stablex.ui.events.WidgetEvent.FREE));
		events.set('widgetResize', new EventMetaData(widgetEvent, macro ru.stablex.ui.events.WidgetEvent.RESIZE));
		events.set('widgetInitialResize', new EventMetaData(widgetEvent, macro ru.stablex.ui.events.WidgetEvent.INITIAL_RESIZE));
		events.set('widgetChange', new EventMetaData(widgetEvent, macro ru.stablex.ui.events.WidgetEvent.CHANGE));
		events.set('widgetScrollStart', new EventMetaData(widgetEvent, macro ru.stablex.ui.events.WidgetEvent.SCROLL_START));
		events.set('widgetScrollStop', new EventMetaData(widgetEvent, macro ru.stablex.ui.events.WidgetEvent.SCROLL_STOP));
		events.set('widgetAdded', new EventMetaData(widgetEvent, macro ru.stablex.ui.events.WidgetEvent.ADDED));
		events.set('widgetRemoved', new EventMetaData(widgetEvent, macro ru.stablex.ui.events.WidgetEvent.REMOVED));

		events.set('dndDrag', new EventMetaData(dndEvent, macro ru.stablex.ui.events.DndEvent.DRAG));
		events.set('dndDrop', new EventMetaData(dndEvent, macro ru.stablex.ui.events.DndEvent.DROP));
		events.set('dndReceive', new EventMetaData(dndEvent, macro ru.stablex.ui.events.DndEvent.RECEIVE));
		events.set('dndReturn', new EventMetaData(dndEvent, macro ru.stablex.ui.events.DndEvent.RETURN));

		events.set('scrollBefore', new EventMetaData(scrollEvent, macro ru.stablex.ui.events.ScrollEvent.BEFORE_SCROLL));

		super(macro : ru.stablex.ui.widgets.Widget, events, CustomLevel(ClassLevel, 1));
	}

	override public function getNodeWriters():Array<IHaxeNodeWriter<Node>> return [new DefaultWidgetWriter(baseType, meta, metaWriter, matchLevel), new DefaultSkinWriter()];
}

class DefaultWidgetWriter extends DisplayObjectMetaWriter {
	override function writeNodes(node:Node, scope:String, writer:IHaxeWriter<Node>, method:Array<String>) {
		for (n in node.nodes) {
			if (n.cData != null && n.cData.rtrim().endsWith("%")) {
				var percentFlag = true;
				n.name.name = switch (n.name.name) {
					case "w": "widthPt";
					case "h": "heightPt";
					case "left" | "top" | "right" | "bottom" : '${n.name.name}Pt';
					case n: percentFlag = false; n;
				}
				if (percentFlag) n.cData = n.cData.rtrim().substr(0, -1);
			}
		}
		super.writeNodes(node, scope, writer, method);
		method.push('$scope._onInitialize();');
	}

	override function postCtorInit(node, method) method.push('this._onCreate();');

	override function postInit(node, method) method.push('res._onCreate();');
}

class DefaultSkinWriter extends hml.xml.XMLWriter.DefaultNodeWriter {
	override public function match(node:Node):MatchLevel return isChildOf(node, macro : ru.stablex.ui.skins.Skin) ? ClassLevel : None;

	override function postCtorInit(node:Node, method:Array<String>) initSkin(node, "this", method);

  	override function postInit(node:Node, method:Array<String>) initSkin(node, "res", method);

  	@:extern inline function initSkin(node, scope, method) {
  		if (isChildOf(node, macro : ru.stablex.ui.widgets.Widget)) {
			method.push('ru.stablex.ui.UIBuilder.applyDefaults($scope);');
			method.push('$scope.onInitialize();');
			method.push('$scope.onCreate();');
		}
  	}
}
#end