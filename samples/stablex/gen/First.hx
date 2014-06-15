package ;

class First extends ru.stablex.ui.widgets.Widget {

    var clickHandler_initialized:Bool = false;

    @:isVar public var clickHandler(get, set):flash.events.MouseEvent -> StdTypes.Void;

    var text2_initialized:Bool = false;

    @:isVar public var text2(get, set):ru.stablex.ui.widgets.Text;

    inline function get_field22():ru.stablex.ui.skins.Paint {
        var res = new ru.stablex.ui.skins.Paint();
        res.color = 0xDDDDDD;
        res.border = 2;
        res.corners = [5];
        return res;
    }

    inline function get_field2():String {
        var res = 'My first widget!';
        return res;
    }

    function set_clickHandler(value:flash.events.MouseEvent -> StdTypes.Void):flash.events.MouseEvent -> StdTypes.Void {
        return clickHandler = value;
    }

    function get_clickHandler():flash.events.MouseEvent -> StdTypes.Void {
        if (clickHandler_initialized) return clickHandler;
        clickHandler_initialized = true;
        var res = function (event:flash.events.MouseEvent):StdTypes.Void { trace('Magic: ${text2.text}'); };
        this.clickHandler = res;
        return res;
    }

    inline function get_field6():ru.stablex.ui.skins.Paint {
        var res = new ru.stablex.ui.skins.Paint();
        res.color = 0xFF0000;
        res.border = 2;
        res.corners = [20];
        return res;
    }

    inline function get_field0():ru.stablex.ui.widgets.Button {
        var res = new ru.stablex.ui.widgets.Button();
        res.top = 100;
        res.text = get_field2();
        res.left = 50;
        res.widthPt = 70;
        res.addEventListener(flash.events.MouseEvent.CLICK, clickHandler);
        res.skin = get_field6();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    function set_text2(value:ru.stablex.ui.widgets.Text):ru.stablex.ui.widgets.Text {
        return text2 = value;
    }

    inline function get_field11():String {
        var res = 'My second widget!';
        return res;
    }

    function get_text2():ru.stablex.ui.widgets.Text {
        if (text2_initialized) return text2;
        text2_initialized = true;
        var res = new ru.stablex.ui.widgets.Text();
        this.text2 = res;
        res.topPt = 45;
        res.text = get_field11();
        res.left = 50;
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field15():String {
        var res = 'Green Button';
        return res;
    }

    inline function get_field17():flash.events.MouseEvent -> StdTypes.Void {
        var res = function (event:flash.events.MouseEvent):StdTypes.Void { trace('green button click'); };
        return res;
    }

    inline function get_field13():GreenButton {
        var res = new GreenButton();
        res.right = 10;
        res.text = get_field15();
        res.bottom = 10;
        res.addEventListener(flash.events.MouseEvent.CLICK, get_field17());
        res.w = 200;
        res._onInitialize();
        res._onCreate();
        return res;
    }

    public function new() {
        super();
        this.h = 300;
        this.w = 400;
        this.skin = get_field22();
        this._onInitialize();
        this.addChild(get_field0());
        this.addChild(text2);
        this.addChild(get_field13());
        this._onCreate();
    }
}
