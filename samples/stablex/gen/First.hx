package ;

class First extends ru.stablex.ui.widgets.Box {

    var clickHandler_initialized:Bool = false;

    @:isVar public var clickHandler(get, set):flash.events.MouseEvent -> StdTypes.Void;

    @:expose inline function get_field2():String {
        var res = 'My first widget!';
        return res;
    }

    function set_clickHandler(value:flash.events.MouseEvent -> StdTypes.Void):flash.events.MouseEvent -> StdTypes.Void {
        return clickHandler = value;
    }

    function get_clickHandler():flash.events.MouseEvent -> StdTypes.Void {
        if (clickHandler_initialized) return clickHandler;
        clickHandler_initialized = true;
        var res = function (event:flash.events.MouseEvent):StdTypes.Void { trace('magic: ${event.localX}'); };
        this.clickHandler = res;
        return res;
    }

    @:expose inline function get_field5():ru.stablex.ui.skins.Paint {
        var res = new ru.stablex.ui.skins.Paint();
        res.color = 0xFF0000;
        res.border = 2;
        res.corners = [20];
        if (Std.is(res, ru.stablex.ui.widgets.Widget)) {
            var w:ru.stablex.ui.widgets.Widget = cast res;
            ru.stablex.ui.UIBuilder.applyDefaults(w);
            w.onInitialize();
            w.onCreate();
        }
        return res;
    }

    @:expose inline function get_field0():ru.stablex.ui.widgets.Button {
        var res = new ru.stablex.ui.widgets.Button();
        res.top = 100;
        res.text = get_field2();
        res.left = 50;
        res.addEventListener("click", clickHandler);
        res.skin = get_field5();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    @:expose inline function get_field11():String {
        var res = 'My second widget!';
        return res;
    }

    @:expose inline function get_field9():ru.stablex.ui.widgets.Text {
        var res = new ru.stablex.ui.widgets.Text();
        res.top = 150;
        res.text = get_field11();
        res.left = 50;
        res._onInitialize();
        res._onCreate();
        return res;
    }

    public function new() {
        super();
        this._onInitialize();
        this.addChild(get_field0());
        this.addChild(get_field9());
        this._onCreate();
    }
}