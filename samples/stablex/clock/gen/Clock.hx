package ;

class Clock extends ru.stablex.ui.widgets.VBox {

    var clock1_initialized:Bool = false;

    @:isVar public var clock1(get, set):ru.stablex.ui.widgets.Clock;

    var clock2_initialized:Bool = false;

    @:isVar public var clock2(get, set):ru.stablex.ui.widgets.Clock;

    var clock3_initialized:Bool = false;

    @:isVar public var clock3(get, set):ru.stablex.ui.widgets.Clock;

    function set_clock1(value:ru.stablex.ui.widgets.Clock):ru.stablex.ui.widgets.Clock {
        return clock1 = value;
    }

    inline function get_field0():flash.events.Event -> StdTypes.Void {
        /* ui/Clock.xml:7 characters: 91-98 */
        var res = function (event:flash.events.Event):StdTypes.Void { clock1.run(); };
        return res;
    }

    function get_clock1():ru.stablex.ui.widgets.Clock {
        /* ui/Clock.xml:7 characters: 5-10 */
        if (clock1_initialized) return clock1;
        clock1_initialized = true;
        var res = new ru.stablex.ui.widgets.Clock();
        this.clock1 = res;
        if(ru.stablex.ui.UIBuilder.defaults.exists("Clock")) {
        	var defFns = ru.stablex.ui.UIBuilder.defaults.get("Clock");
        	for(def in ["Default"]) {
        		var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
        		if(defaultsFn != null) defaultsFn(res);
        	}
        }
        res.addEventListener(flash.events.Event.ADDED_TO_STAGE, get_field0());
        /* ui/Clock.xml:7 characters: 63-70 */
        res.forward = false;
        /* ui/Clock.xml:7 characters: 12-17 */
        res.value = 60*60*2;
        /* ui/Clock.xml:7 characters: 28-38 */
        res.timeFormat = 'Countdown: %H:%M:%S';
        res._onInitialize();
        res._onCreate();
        return res;
    }

    function set_clock2(value:ru.stablex.ui.widgets.Clock):ru.stablex.ui.widgets.Clock {
        return clock2 = value;
    }

    inline function get_field1():flash.events.Event -> StdTypes.Void {
        /* ui/Clock.xml:10 characters: 24-31 */
        var res = function (event:flash.events.Event):StdTypes.Void { this.clock2.run(); };
        return res;
    }

    function get_clock2():ru.stablex.ui.widgets.Clock {
        /* ui/Clock.xml:10 characters: 5-10 */
        if (clock2_initialized) return clock2;
        clock2_initialized = true;
        var res = new ru.stablex.ui.widgets.Clock();
        this.clock2 = res;
        if(ru.stablex.ui.UIBuilder.defaults.exists("Clock")) {
        	var defFns = ru.stablex.ui.UIBuilder.defaults.get("Clock");
        	for(def in ["Default"]) {
        		var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
        		if(defaultsFn != null) defaultsFn(res);
        	}
        }
        res.addEventListener(flash.events.Event.ADDED_TO_STAGE, get_field1());
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field2():ru.stablex.ui.widgets.Clock {
        /* ui/Clock.xml:13 characters: 5-10 */
        var res = new ru.stablex.ui.widgets.Clock();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Clock")) {
        	var defFns = ru.stablex.ui.UIBuilder.defaults.get("Clock");
        	for(def in ["Default"]) {
        		var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
        		if(defaultsFn != null) defaultsFn(res);
        	}
        }
        /* ui/Clock.xml:13 characters: 12-17 */
        res.value = Std.int(60*90);
        /* ui/Clock.xml:13 characters: 35-45 */
        res.timeFormat = '%H:%M';
        res._onInitialize();
        res._onCreate();
        return res;
    }

    function set_clock3(value:ru.stablex.ui.widgets.Clock):ru.stablex.ui.widgets.Clock {
        return clock3 = value;
    }

    inline function get_field3():flash.events.Event -> StdTypes.Void {
        /* ui/Clock.xml:17 characters: 9-16 */
        var res = function (event:flash.events.Event):StdTypes.Void { clock3.run(); };
        return res;
    }

    inline function get_field4():ru.stablex.ui.events.WidgetEvent -> StdTypes.Void {
        /* ui/Clock.xml:18 characters: 9-21 */
        var res = function (event:ru.stablex.ui.events.WidgetEvent):StdTypes.Void {  if( clock3.value == 0 ) clock3.free(); };
        return res;
    }

    function get_clock3():ru.stablex.ui.widgets.Clock {
        /* ui/Clock.xml:16 characters: 5-10 */
        if (clock3_initialized) return clock3;
        clock3_initialized = true;
        var res = new ru.stablex.ui.widgets.Clock();
        this.clock3 = res;
        if(ru.stablex.ui.UIBuilder.defaults.exists("Clock")) {
        	var defFns = ru.stablex.ui.UIBuilder.defaults.get("Clock");
        	for(def in ["Default"]) {
        		var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
        		if(defaultsFn != null) defaultsFn(res);
        	}
        }
        res.addEventListener(flash.events.Event.ADDED_TO_STAGE, get_field3());
        /* ui/Clock.xml:16 characters: 73-80 */
        res.forward = false;
        /* ui/Clock.xml:16 characters: 89-94 */
        res.value = 60;
        res.addEventListener(ru.stablex.ui.events.WidgetEvent.CHANGE, get_field4());
        /* ui/Clock.xml:16 characters: 24-34 */
        res.timeFormat = 'Self destruction in %s seconds...';
        res._onInitialize();
        res._onCreate();
        return res;
    }

    public function new() {
        /* ui/Clock.xml:3 characters: 1-5 */
        super();
        if(ru.stablex.ui.UIBuilder.defaults.exists("VBox")) {
        	var defFns = ru.stablex.ui.UIBuilder.defaults.get("VBox");
        	for(def in ["Default"]) {
        		var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
        		if(defaultsFn != null) defaultsFn(this);
        	}
        }
        /* ui/Clock.xml:4 characters: 84-96 */
        this.childPadding = 20;
        /* ui/Clock.xml:4 characters: 44-45 */
        this.h = flash.Lib.current.stage.stageHeight;
        /* ui/Clock.xml:4 characters: 5-6 */
        this.w = flash.Lib.current.stage.stageWidth;
        this._onInitialize();
        this.addChild(clock1);
        this.addChild(clock2);
        this.addChild(get_field2());
        this.addChild(clock3);
        this._onCreate();
    }
}
