package ;

class Position extends ru.stablex.ui.widgets.Widget {

    var child_initialized:Bool = false;

    @:isVar public var child(get, set):ru.stablex.ui.widgets.Widget;

    inline function get_field0():flash.events.MouseEvent -> StdTypes.Void {
        var res = function (event:flash.events.MouseEvent):StdTypes.Void {  child.left = 30 ; };
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
        res.text = 'Click here to set \'child.left = 30\'';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_field0());
        res.autoHeight = true;
        res.w = 300;
        res.skin = get_field1();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field3():flash.events.MouseEvent -> StdTypes.Void {
        var res = function (event:flash.events.MouseEvent):StdTypes.Void {  child.leftPt = 30;  };
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
        res.text = 'Click here to set \'child.leftPt = 30\'';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_field3());
        res.autoHeight = true;
        res.w = 300;
        res.skin = get_field4();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field6():flash.events.MouseEvent -> StdTypes.Void {
        var res = function (event:flash.events.MouseEvent):StdTypes.Void {  child.right = 30;  };
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
        res.text = 'Click here to set \'child.right = 30\'';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_field6());
        res.autoHeight = true;
        res.w = 300;
        res.skin = get_field7();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field9():flash.events.MouseEvent -> StdTypes.Void {
        var res = function (event:flash.events.MouseEvent):StdTypes.Void {  child.rightPt = 30;  };
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
        res.text = 'Click here to set \'child.rightPt = 30\'';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_field9());
        res.autoHeight = true;
        res.w = 300;
        res.skin = get_field10();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field12():flash.events.MouseEvent -> StdTypes.Void {
        var res = function (event:flash.events.MouseEvent):StdTypes.Void {  child.top = 30;  };
        return res;
    }

    inline function get_field13():ru.stablex.ui.skins.Paint {
        var res = new ru.stablex.ui.skins.Paint();
        res.color = 0x00FF00;
        res.border = 1;
        return res;
    }

    inline function get_field14():ru.stablex.ui.widgets.Button {
        var res = new ru.stablex.ui.widgets.Button();
        res.text = 'Click here to set \'child.top = 30\'';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_field12());
        res.autoHeight = true;
        res.w = 300;
        res.skin = get_field13();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field15():flash.events.MouseEvent -> StdTypes.Void {
        var res = function (event:flash.events.MouseEvent):StdTypes.Void {  child.topPt = 30;  };
        return res;
    }

    inline function get_field16():ru.stablex.ui.skins.Paint {
        var res = new ru.stablex.ui.skins.Paint();
        res.color = 0x00FF00;
        res.border = 1;
        return res;
    }

    inline function get_field17():ru.stablex.ui.widgets.Button {
        var res = new ru.stablex.ui.widgets.Button();
        res.text = 'Click here to set \'child.topPt = 30\'';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_field15());
        res.autoHeight = true;
        res.w = 300;
        res.skin = get_field16();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field18():flash.events.MouseEvent -> StdTypes.Void {
        var res = function (event:flash.events.MouseEvent):StdTypes.Void {  child.bottom = 30;  };
        return res;
    }

    inline function get_field19():ru.stablex.ui.skins.Paint {
        var res = new ru.stablex.ui.skins.Paint();
        res.color = 0x00FF00;
        res.border = 1;
        return res;
    }

    inline function get_field20():ru.stablex.ui.widgets.Button {
        var res = new ru.stablex.ui.widgets.Button();
        res.text = 'Click here to set \'child.bottom = 30\'';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_field18());
        res.autoHeight = true;
        res.w = 300;
        res.skin = get_field19();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field21():flash.events.MouseEvent -> StdTypes.Void {
        var res = function (event:flash.events.MouseEvent):StdTypes.Void {  child.bottomPt = 30;  };
        return res;
    }

    inline function get_field22():ru.stablex.ui.skins.Paint {
        var res = new ru.stablex.ui.skins.Paint();
        res.color = 0x00FF00;
        res.border = 1;
        return res;
    }

    inline function get_field23():ru.stablex.ui.widgets.Button {
        var res = new ru.stablex.ui.widgets.Button();
        res.text = 'Click here to set \'child.bottomPt = 30\'';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_field21());
        res.autoHeight = true;
        res.w = 300;
        res.skin = get_field22();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field24():ru.stablex.ui.widgets.VBox {
        var res = new ru.stablex.ui.widgets.VBox();
        res.childPadding = 10;
        res.padding = 10;
        res.w = 800;
        res._onInitialize();
        res.addChild(get_field2());
        res.addChild(get_field5());
        res.addChild(get_field8());
        res.addChild(get_field11());
        res.addChild(get_field14());
        res.addChild(get_field17());
        res.addChild(get_field20());
        res.addChild(get_field23());
        res._onCreate();
        return res;
    }

    inline function get_field25():ru.stablex.ui.skins.Paint {
        var res = new ru.stablex.ui.skins.Paint();
        res.color = 0x005500;
        res.border = 1;
        return res;
    }

    function set_child(value:ru.stablex.ui.widgets.Widget):ru.stablex.ui.widgets.Widget {
        return child = value;
    }

    inline function get_field26():ru.stablex.ui.skins.Paint {
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
        res.h = 50;
        res.topPt = 50;
        res.leftPt = 50;
        res.w = 50;
        res.skin = get_field26();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field27():ru.stablex.ui.widgets.Widget {
        var res = new ru.stablex.ui.widgets.Widget();
        res.h = 300;
        res.bottom = 10;
        res.left = 50;
        res.w = 700;
        res.skin = get_field25();
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
        this.addChild(get_field24());
        this.addChild(get_field27());
        this._onCreate();
    }
}
