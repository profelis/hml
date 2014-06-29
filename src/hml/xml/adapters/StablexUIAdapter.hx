package hml.xml.adapters;

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

#if macro
class StablexUIAdapter extends MergedAdapter<XMLData, Node, Type> {
	public function new() {
		super([
			new WidgetAdapter(),
			new DisplayObjectAdapter(),
			new IEventDispatcherAdapter(),
			new hml.xml.XMLProcessor.DefaultXMLAdapter()
		]);
	}

	static public function register():Void {
		hml.Hml.registerProcessor(new hml.xml.XMLProcessor([new StablexUIAdapter()]));
	}
}

class WidgetAdapter extends DisplayObjectAdapter {
	public function new() {
		var eventType = (macro : flash.events.Event -> Void).toType();
		var widgetEvent = (macro : ru.stablex.ui.events.WidgetEvent -> Void).toType();
		var dndEvent = (macro : ru.stablex.ui.events.DndEvent -> Void).toType();
		var scrollEvent = (macro : ru.stablex.ui.events.ScrollEvent -> Void).toType();

		var events:Map<String, MetaData> = new Map();
		inline function addMeta(data:MetaData):Void {
			events.set(data.name, data);
		}
		addMeta(new EventMetaData(eventType, 'display', macro flash.events.Event.ADDED_TO_STAGE));

		addMeta(new EventMetaData(widgetEvent, 'widgetCreate', macro ru.stablex.ui.events.WidgetEvent.CREATE));
		addMeta(new EventMetaData(widgetEvent, 'widgetFree', macro ru.stablex.ui.events.WidgetEvent.FREE));
		addMeta(new EventMetaData(widgetEvent, 'widgetResize', macro ru.stablex.ui.events.WidgetEvent.RESIZE));
		addMeta(new EventMetaData(widgetEvent, 'widgetInitialResize', macro ru.stablex.ui.events.WidgetEvent.INITIAL_RESIZE));
		addMeta(new EventMetaData(widgetEvent, 'widgetChange', macro ru.stablex.ui.events.WidgetEvent.CHANGE));
		addMeta(new EventMetaData(widgetEvent, 'widgetScrollStart', macro ru.stablex.ui.events.WidgetEvent.SCROLL_START));
		addMeta(new EventMetaData(widgetEvent, 'widgetScrollStop', macro ru.stablex.ui.events.WidgetEvent.SCROLL_STOP));
		addMeta(new EventMetaData(widgetEvent, 'widgetAdded', macro ru.stablex.ui.events.WidgetEvent.ADDED));
		addMeta(new EventMetaData(widgetEvent, 'widgetRemoved', macro ru.stablex.ui.events.WidgetEvent.REMOVED));

		addMeta(new EventMetaData(dndEvent, 'dndDrag', macro ru.stablex.ui.events.DndEvent.DRAG));
		addMeta(new EventMetaData(dndEvent, 'dndDrop', macro ru.stablex.ui.events.DndEvent.DROP));
		addMeta(new EventMetaData(dndEvent, 'dndReceive', macro ru.stablex.ui.events.DndEvent.RECEIVE));
		addMeta(new EventMetaData(dndEvent, 'dndReturn', macro ru.stablex.ui.events.DndEvent.RETURN));

		addMeta(new EventMetaData(scrollEvent, 'scrollBefore', macro ru.stablex.ui.events.ScrollEvent.BEFORE_SCROLL));

		super(macro : ru.stablex.ui.widgets.Widget, events, CustomLevel(ClassLevel, 20));
	}

	override public function getNodeWriters():Array<IHaxeNodeWriter<Node>> {
		return [new DefaultWidgetWriter(baseType, metaWriter, matchLevel), new DefaultSkinWriter()];
	}
}

class DefaultWidgetWriter extends DisplayObjectWithMetaWriter {
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

	override function postCtorInit(node, method) {
		method.push('this._onCreate();');
	}

	override function postInit(node, method) {
		method.push('res._onCreate();');
	}
}

class DefaultSkinWriter extends hml.xml.XMLWriter.DefaultNodeWriter {
	override public function match(node:Node):MatchLevel {
		return isChildOf(node, macro : ru.stablex.ui.skins.Skin) ? ClassLevel : None;
	}

	override function postCtorInit(node:Node, method:Array<String>) {
		initSkin(node, "this", method);
	}

  	override function postInit(node:Node, method:Array<String>) {
  		initSkin(node, "res", method);
  	}

  	@:extern inline function initSkin(node, scope, method) {
  		if (isChildOf(node, macro : ru.stablex.ui.widgets.Widget)) {
			method.push('ru.stablex.ui.UIBuilder.applyDefaults($scope);');
			method.push('$scope.onInitialize();');
			method.push('$scope.onCreate();');
		}
  	}
}
#end