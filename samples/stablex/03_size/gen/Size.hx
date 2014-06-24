package ;

class Size extends ru.stablex.ui.widgets.Widget {

    var child_initialized:Bool = false;

    @:isVar public var child(get, set):ru.stablex.ui.widgets.Widget;

    inline function get_field0():flash.events.MouseEvent -> StdTypes.Void {
        var res = function (event:flash.events.MouseEvent):StdTypes.Void {  child.w = 50;  };
        return res;
    }

    inline function get_field1():ru.stablex.ui.skins.Paint {
        var res = new ru.stablex.ui.skins.Paint();
        res.color = 0x00FF00;
        res.border = 1;
        return res;
    }

    inline function get_field2():ru.stablex.ui.widgets.Button {
        var res = new ru.stablex.ui.widgets.Button();
        res.text = 'Click here to set \'child.w = 50\'';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_field0());
        res.autoHeight = true;
        res.w = 300;
        res.skin = get_field1();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field3():flash.events.MouseEvent -> StdTypes.Void {
        var res = function (event:flash.events.MouseEvent):StdTypes.Void {  child.widthPt = 50;  };
        return res;
    }

    inline function get_field4():ru.stablex.ui.skins.Paint {
        var res = new ru.stablex.ui.skins.Paint();
        res.color = 0x00FF00;
        res.border = 1;
        return res;
    }

    inline function get_field5():ru.stablex.ui.widgets.Button {
        var res = new ru.stablex.ui.widgets.Button();
        res.text = 'Click here to set \'child.widthPt = 50\'';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_field3());
        res.autoHeight = true;
        res.w = 300;
        res.skin = get_field4();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field6():flash.events.MouseEvent -> StdTypes.Void {
        var res = function (event:flash.events.MouseEvent):StdTypes.Void {  child.h = 50;  };
        return res;
    }

    inline function get_field7():ru.stablex.ui.skins.Paint {
        var res = new ru.stablex.ui.skins.Paint();
        res.color = 0x00FF00;
        res.border = 1;
        return res;
    }

    inline function get_field8():ru.stablex.ui.widgets.Button {
        var res = new ru.stablex.ui.widgets.Button();
        res.text = 'Click here to set \'child.h = 50\'';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_field6());
        res.autoHeight = true;
        res.w = 300;
        res.skin = get_field7();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field9():flash.events.MouseEvent -> StdTypes.Void {
        var res = function (event:flash.events.MouseEvent):StdTypes.Void {  child.heightPt = 50;  };
        return res;
    }

    inline function get_field10():ru.stablex.ui.skins.Paint {
        var res = new ru.stablex.ui.skins.Paint();
        res.color = 0x00FF00;
        res.border = 1;
        return res;
    }

    inline function get_field11():ru.stablex.ui.widgets.Button {
        var res = new ru.stablex.ui.widgets.Button();
        res.text = 'Click here to set \'child.heightPt = 50\'';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_field9());
        res.autoHeight = true;
        res.w = 300;
        res.skin = get_field10();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field12():ru.stablex.ui.widgets.VBox {
        var res = new ru.stablex.ui.widgets.VBox();
        res.childPadding = 10;
        res.padding = 10;
        res.autoHeight = true;
        res.w = 800;
        res._onInitialize();
        res.addChild(get_field2());
        res.addChild(get_field5());
        res.addChild(get_field8());
        res.addChild(get_field11());
        res._onCreate();
        return res;
    }

    inline function get_field13():ru.stablex.ui.skins.Paint {
        var res = new ru.stablex.ui.skins.Paint();
        res.color = 0x005500;
        res.border = 1;
        return res;
    }

    function set_child(value:ru.stablex.ui.widgets.Widget):ru.stablex.ui.widgets.Widget {
        return child = value;
    }

    inline function get_field14():ru.stablex.ui.skins.Paint {
        var res = new ru.stablex.ui.skins.Paint();
        res.color = 0x550000;
        res.border = 1;
        return res;
    }

    function get_child():ru.stablex.ui.widgets.Widget {
        if (child_initialized) return child;
        child_initialized = true;
        var res = new ru.stablex.ui.widgets.Widget();
        this.child = res;
        res.top = 50;
        res.h = 100;
        res.left = 50;
        res.w = 100;
        res.skin = get_field14();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field15():ru.stablex.ui.widgets.Widget {
        var res = new ru.stablex.ui.widgets.Widget();
        res.h = 400;
        res.bottom = 10;
        res.left = 50;
        res.w = 700;
        res.skin = get_field13();
        res._onInitialize();
        res.addChild(child);
        res._onCreate();
        return res;
    }

    public function new() {
        super();
        this.h = 600;
        this.w = 800;
        this._onInitialize();
        this.addChild(get_field12());
        this.addChild(get_field15());
        this._onCreate();
    }
}
