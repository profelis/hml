package hml.xml.adapters;

import hml.xml.Data;
import hml.xml.XMLProcessor;
import hml.xml.XMLWriter;
import hml.base.MatchLevel;
import hml.xml.XMLWriter.DefaultNodeWriter;
import hml.xml.adapters.BaseMetaAdapter;

import haxe.macro.Expr;

using haxe.macro.Tools;

using hml.base.MatchLevel;

using StringTools;

class EventMetaData extends MetaData {
	public var name:Expr;

	public function new(type:haxe.macro.Type, name:Expr) {
		super(type);
		this.name = name;
	}
}

class FlashAdapter extends EventDispatcherAdapter {
	public function new(?baseType:ComplexType, ?events:Map<String, MetaData>, ?matchLevel:MatchLevel) {
		if (baseType == null) baseType = macro : flash.display.DisplayObject;
		if (matchLevel == null) matchLevel = ClassLevel;

		var mouseEventType = (macro : flash.events.MouseEvent -> Void).toType();
		var eventType = (macro : flash.events.Event -> Void).toType();

		events = events != null ? events : new Map();
		events.set('click', new EventMetaData(mouseEventType, macro flash.events.MouseEvent.CLICK));
		events.set('mouseDown', new EventMetaData(mouseEventType, macro flash.events.MouseEvent.MOUSE_DOWN));
		events.set('mouseUp', new EventMetaData(mouseEventType, macro flash.events.MouseEvent.MOUSE_UP));
		events.set('mouseMove', new EventMetaData(mouseEventType, macro flash.events.MouseEvent.MOUSE_MOVE));
		events.set('mouseOut', new EventMetaData(mouseEventType, macro flash.events.MouseEvent.MOUSE_OUT));
		events.set('mouseOver', new EventMetaData(mouseEventType, macro flash.events.MouseEvent.MOUSE_OVER));
		events.set('rollOver', new EventMetaData(mouseEventType, macro flash.events.MouseEvent.ROLL_OVER));
		events.set('rollOut', new EventMetaData(mouseEventType, macro flash.events.MouseEvent.ROLL_OUT));
		events.set('mouseWheel', new EventMetaData(mouseEventType, macro flash.events.MouseEvent.MOUSE_WHEEL));

		events.set('enterFrame', new EventMetaData(eventType, macro flash.events.Event.ENTER_FRAME));
		events.set('render', new EventMetaData(eventType, macro flash.events.Event.RENDER));
		events.set('added', new EventMetaData(eventType, macro flash.events.Event.ADDED));
		events.set('addedToStage', new EventMetaData(eventType, macro flash.events.Event.ADDED_TO_STAGE));
		events.set('removed', new EventMetaData(eventType, macro flash.events.Event.REMOVED));
		events.set('removedFromStage', new EventMetaData(eventType, macro flash.events.Event.REMOVED_FROM_STAGE));

		super(baseType, events, matchLevel);
	}

	override public function getNodeWriters():Array<IHaxeNodeWriter<Node>> {
		return [new DisplayObjectMetaWriter(baseType, meta, metaWriter, matchLevel)];
	}
}

class EventDispatcherAdapter extends BaseMetaAdapter {
	public function new(baseType:ComplexType, events:Map<String, MetaData>, matchLevel:MatchLevel) {
		super(baseType, events, new EventDispatcherMetaWriter(events), matchLevel);
	}
}

class DisplayObjectMetaWriter extends MetaWriter {
	override function child(node:Node, scope:String, child:Node, method:Array<String>, assign = false):Void {
		method.push('$scope.addChild(${universalGet(child)});');
	}
}

class EventDispatcherMetaWriter implements IMetaWriter {

	var events:Map<String, MetaData>;
	
	public function new(events:Map<String, MetaData>) {
		this.events = events;
	}

	public function writeMeta(node:Node, scope:String, parent:Node, metaWriter:MetaWriter, writer:IHaxeWriter<Node>, method:Array<String>):Void {
		var eventData:MetaData = cast events.get(node.name.name);
		var name:Expr = Std.is(eventData, EventMetaData) ? cast(eventData, EventMetaData).name : macro $v{node.name.name};
		method.push('$scope.addEventListener(${metaWriter.printer.printExpr(name)}, ${metaWriter.universalGet(node)});');
		switch (node.nativeType) {
			case TFun(t, ret):
				var body = node.cData;
				if (!body.rtrim().endsWith(";")) body += ";";
				node.cData = 'function (event:${metaWriter.printer.printComplexType(t[0].t.toComplexType())}):' +
					'${metaWriter.printer.printComplexType(ret.toComplexType())} { ${body} }';
			case _:
		}
		writer.writeNode(node);
	}
}