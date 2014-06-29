package hml.xml.adapters;

import hml.xml.Data;
import hml.xml.XMLProcessor;
import hml.xml.XMLWriter;
import hml.base.MatchLevel;
import hml.xml.XMLWriter.DefaultNodeWriter;
import hml.xml.adapters.BaseMetaAdapter;
import hml.base.MacroTools;

import haxe.macro.Context;
import haxe.macro.Expr;

using haxe.macro.Tools;
using hml.base.MacroTools;

using hml.base.MatchLevel;

using StringTools;

class EventMetaData extends MetaData {
	public var nameExpr:Expr;

	public function new(type:haxe.macro.Type, name:String, nameExpr:Expr) {
		super(type, name);
		this.nameExpr = nameExpr;
	}

	override public function getExpr():Expr {
		return nameExpr != null ? nameExpr : macro $v{name};
	}
}

class FlashAdapter extends MergedAdapter<XMLData, Node, Type> {
	public function new() {
		super([
			new DisplayObjectAdapter(),
			new IEventDispatcherAdapter(),
			new hml.xml.XMLProcessor.DefaultXMLAdapter()
		]);
	}

	static public function register():Void {
		hml.Hml.registerProcessor(new hml.xml.XMLProcessor([new FlashAdapter()]));
	}
}

class DisplayObjectAdapter extends BaseEventDispatcherAdapter {
	public function new(?baseType:ComplexType, ?events:Map<String, MetaData>, ?matchLevel:MatchLevel) {
		if (baseType == null) baseType = macro : flash.display.DisplayObject;
		if (matchLevel == null) matchLevel = CustomLevel(ClassLevel, 10);

		var mouseEventType = (macro : flash.events.MouseEvent -> Void).toType();
		var eventType = (macro : flash.events.Event -> Void).toType();

		events = events != null ? events : new Map();

		inline function addMeta(data:MetaData):Void {
			events.set(data.name, data);
		}
		inline function addMouseEventMeta(type:String, nameExpr:Expr) {
			addMeta(new EventMetaData(mouseEventType, type, nameExpr));
		}
		inline function addEventMeta(type:String, nameExpr:Expr) {
			addMeta(new EventMetaData(eventType, type, nameExpr));
		}

		addMouseEventMeta('click', macro flash.events.MouseEvent.CLICK);
		addMouseEventMeta('mouseDown', macro flash.events.MouseEvent.MOUSE_DOWN);
		addMouseEventMeta('mouseUp', macro flash.events.MouseEvent.MOUSE_UP);
		addMouseEventMeta('mouseMove', macro flash.events.MouseEvent.MOUSE_MOVE);
		addMouseEventMeta('mouseOut', macro flash.events.MouseEvent.MOUSE_OUT);
		addMouseEventMeta('mouseOver', macro flash.events.MouseEvent.MOUSE_OVER);
		addMouseEventMeta('rollOver', macro flash.events.MouseEvent.ROLL_OVER);
		addMouseEventMeta('rollOut', macro flash.events.MouseEvent.ROLL_OUT);
		addMouseEventMeta('mouseWheel', macro flash.events.MouseEvent.MOUSE_WHEEL);

		addEventMeta('enterFrame', macro flash.events.Event.ENTER_FRAME);
		addEventMeta('render', macro flash.events.Event.RENDER);
		addEventMeta('added', macro flash.events.Event.ADDED);
		addEventMeta('addedToStage', macro flash.events.Event.ADDED_TO_STAGE);
		addEventMeta('removed', macro flash.events.Event.REMOVED);
		addEventMeta('removedFromStage', macro flash.events.Event.REMOVED_FROM_STAGE);

		super(baseType, events, matchLevel);
	}

	override public function getNodeWriters():Array<IHaxeNodeWriter<Node>> {
		return [new DisplayObjectWithMetaWriter(baseType, metaWriter, matchLevel)];
	}
}

class DisplayObjectWithMetaWriter extends BaseNodeWithMetaWriter {
	override function child(node:Node, scope:String, child:Node, method:Array<String>, assign = false):Void {
		method.push('$scope.addChild(${universalGet(child)});');
	}
}

class IEventDispatcherAdapter extends BaseEventDispatcherAdapter {
	public function new() {
		super(macro : flash.events.IEventDispatcher, new Map(), ClassLevel);
	}
}

class BaseEventDispatcherAdapter extends BaseMetaAdapter {
	public function new(baseType:ComplexType, events:Map<String, MetaData>, matchLevel:MatchLevel) {
		super(baseType, events, new EventDispatcherMetaWriter(), matchLevel);
	}

	override public function getTypeResolvers():Array<IHaxeTypeResolver<Node, Type>> {
		return [new EventMetaResolver(baseType, meta)];
	}
}

class EventMetaResolver extends BaseMetaResolver {
	public function new(baseType:ComplexType, meta:Map<String, MetaData>) {
		super(baseType, meta);
	}

	static var cache:Map<String, Map<String, MetaData>> = new Map();

	override public function hasField(node:Node, qName:XMLQName):Bool {
		if (qName.ns != node.name.ns) return false;

		var res = super.hasField(node, qName);
		if (res) return res;

		if (node.nativeType != null && node.nativeType.isChildOf(baseType)) {
			var clazz = node.nativeType.getClass();
			while (clazz != null && clazz.isChildOf(baseType)) {
				var meta:Map<String, MetaData> = cache.get(clazz.typeName());
				if (meta == null) cache.set(clazz.typeName(), meta = getClassMeta(clazz));
				if (meta.exists(qName.name)) {
					var key = BaseMetaResolver.metaKey(qName);
					var extra:Map<XMLQName, MetaData> = node.extra[key];
					if (extra == null) node.extra[key] = extra = new Map();
					extra.set(qName, meta.get(qName.name));
					return true;
				}
				clazz = clazz.superClass != null ? clazz.superClass.t.get() : null;
			}
		}

		return false;
	}

	function getClassMeta(clazz:haxe.macro.Type.ClassType):Map<String, MetaData> {
		var res = new Map<String, MetaData>();
		var meta = clazz.meta.get();
		for (m in meta) {
			if (m.name != ":meta") continue;
			switch (m.params) {
				case [macro Event($a{args})]:
					var name:String = null;
					var type:String = null;

					inline function extractString(e:Expr) {
						return switch (e.expr) {
							case EConst(CString(s)): s;
							case _: null;
						}
					}
					for (a in args) {
						switch (a) {
							case macro name = $n:
								name = extractString(n);
								if (name == null)
									Context.warning('can\'t find "name" arg in Event meta: ${a.toString()}', m.pos);
							case macro type = $t:
								type = extractString(t);
								if (type == null)
									Context.warning('can\'t find "type" arg in Event meta: ${a.toString()}', m.pos);
							case _: 
								Context.warning('unsupported arg in Event meta: ${a.toString()}', m.pos);
						}
					}
					var hxType = null;
					try {
						hxType = Context.getType(type);
					} catch (e:Dynamic) {}
					if (hxType == null) Context.warning('can\'t resolve Event type "$type"', m.pos);

					var complexType = hxType.toComplexType();
					res.set(name, new MetaData((macro : $complexType -> Void).toType(), name));

				case _: Context.warning("unknown meta: " + m.params, Context.currentPos());
			}
		}
		return res;
	}
}

class EventDispatcherMetaWriter implements IMetaWriter {
	
	public function new() {}

	public function writeMeta(node:Node, scope:String, metaData:MetaData, parent:Node, metaWriter:DefaultNodeWriter, writer:IHaxeWriter<Node>, method:Array<String>):Void {
		method.push('$scope.addEventListener(${metaWriter.printer.printExpr(metaData.getExpr())}, ${metaWriter.universalGet(node)});');
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