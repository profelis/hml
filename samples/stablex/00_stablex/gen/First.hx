package ;

class First extends ru.stablex.ui.widgets.Widget {

    var clickHandler_initialized:Bool = false;

    @:isVar public var clickHandler(get, set):flash.events.MouseEvent -> StdTypes.Void;

    var text2_initialized:Bool = false;

    @:isVar public var text2(get, set):ru.stablex.ui.widgets.Text;

    inline function get_field0():ru.stablex.ui.skins.Paint {
        /* ui/First.xml:5 characters: 3-13 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/First.xml:5 characters: 15-20 */
        res.color = 0xDDDDDD;
        /* ui/First.xml:5 characters: 32-38 */
        res.border = 2;
        /* ui/First.xml:5 characters: 43-50 */
        res.corners = [5];
        return res;
    }

    function set_clickHandler(value:flash.events.MouseEvent -> StdTypes.Void):flash.events.MouseEvent -> StdTypes.Void {
        clickHandler_initialized = true;
        return clickHandler = value;
    }

    function get_clickHandler():flash.events.MouseEvent -> StdTypes.Void {
        /* ui/First.xml:8 characters: 3-8 */
        if (clickHandler_initialized) return clickHandler;
        clickHandler_initialized = true;
        var res = function (event:flash.events.MouseEvent):StdTypes.Void { trace('Magic: ${text2.text}'); };
        this.clickHandler = res;
        return res;
    }

    inline function get_field1():ru.stablex.ui.skins.Paint {
        /* ui/First.xml:10 characters: 4-14 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/First.xml:10 characters: 16-21 */
        res.color = 0xFF0000;
        /* ui/First.xml:10 characters: 33-39 */
        res.border = 2;
        /* ui/First.xml:10 characters: 44-51 */
        res.corners = [20];
        return res;
    }

    inline function get_field2():ru.stablex.ui.widgets.Button {
        /* ui/First.xml:7 characters: 2-8 */
        var res = new ru.stablex.ui.widgets.Button();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Button")) {
        	var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
        	for(def in ["Default"]) {
        		var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
        		if(defaultsFn != null) defaultsFn(res);
        	}
        }
        /* ui/First.xml:7 characters: 20-23 */
        res.top = 100;
        /* ui/First.xml:7 characters: 38-42 */
        res.text = 'My first widget!';
        /* ui/First.xml:7 characters: 10-14 */
        res.left = 50;
        /* ui/First.xml:7 characters: 30-31 */
        res.widthPt = 70;
        res.addEventListener(flash.events.MouseEvent.CLICK, clickHandler);
        /* ui/First.xml:9 characters: 3-7 */
        res.skin = get_field1();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    function set_text2(value:ru.stablex.ui.widgets.Text):ru.stablex.ui.widgets.Text {
        text2_initialized = true;
        return text2 = value;
    }

    function get_text2():ru.stablex.ui.widgets.Text {
        /* ui/First.xml:13 characters: 2-6 */
        if (text2_initialized) return text2;
        text2_initialized = true;
        var res = new ru.stablex.ui.widgets.Text();
        this.text2 = res;
        if(ru.stablex.ui.UIBuilder.defaults.exists("Text")) {
        	var defFns = ru.stablex.ui.UIBuilder.defaults.get("Text");
        	for(def in ["Default"]) {
        		var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
        		if(defaultsFn != null) defaultsFn(res);
        	}
        }
        /* ui/First.xml:13 characters: 29-32 */
        res.topPt = 45;
        /* ui/First.xml:13 characters: 39-43 */
        res.text = 'My second widget!';
        /* ui/First.xml:13 characters: 19-23 */
        res.left = 50;
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field3():flash.events.MouseEvent -> StdTypes.Void {
        /* ui/First.xml:14 characters: 83-88 */
        var res = function (event:flash.events.MouseEvent):StdTypes.Void { trace('green button click'); };
        return res;
    }

    inline function get_field4():GreenButton {
        /* ui/First.xml:14 characters: 2-16 */
        var res = new GreenButton();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Button")) {
        	var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
        	for(def in ["Default"]) {
        		var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
        		if(defaultsFn != null) defaultsFn(res);
        	}
        }
        /* ui/First.xml:14 characters: 30-35 */
        res.right = 10;
        /* ui/First.xml:14 characters: 61-65 */
        res.text = 'Green Button';
        /* ui/First.xml:14 characters: 41-47 */
        res.bottom = 10;
        res.addEventListener(flash.events.MouseEvent.CLICK, get_field3());
        /* ui/First.xml:14 characters: 53-54 */
        res.w = 200;
        res._onInitialize();
        res._onCreate();
        return res;
    }

    public function new() {
        /* ui/First.xml:3 characters: 1-7 */
        super();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Widget")) {
        	var defFns = ru.stablex.ui.UIBuilder.defaults.get("Widget");
        	for(def in ["Default"]) {
        		var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
        		if(defaultsFn != null) defaultsFn(this);
        	}
        }
        /* ui/First.xml:3 characters: 80-81 */
        this.h = 300;
        /* ui/First.xml:3 characters: 72-73 */
        this.w = 400;
        /* ui/First.xml:4 characters: 2-6 */
        this.skin = get_field0();
        this._onInitialize();
        this.addChild(get_field2());
        this.addChild(text2);
        this.addChild(get_field4());
        this._onCreate();
    }
}
