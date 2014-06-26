package ;

class Size extends ru.stablex.ui.widgets.Widget {

    var child_initialized:Bool = false;

    @:isVar public var child(get, set):ru.stablex.ui.widgets.Widget;

    inline function get_field0():flash.events.MouseEvent -> StdTypes.Void {
        /* ui/Size.xml:7 characters: 87-92 */
        var res = function (event:flash.events.MouseEvent):StdTypes.Void {  child.w = 50;  };
        return res;
    }

    inline function get_field1():ru.stablex.ui.skins.Paint {
        /* ui/Size.xml:8 characters: 19-29 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/Size.xml:8 characters: 42-47 */
        res.color = 0x00FF00;
        /* ui/Size.xml:8 characters: 31-37 */
        res.border = 1;
        return res;
    }

    inline function get_field2():ru.stablex.ui.widgets.Button {
        /* ui/Size.xml:7 characters: 9-15 */
        var res = new ru.stablex.ui.widgets.Button();
        /* ui/Size.xml:7 characters: 25-29 */
        res.text = 'Click here to set \'child.w = 50\'';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_field0());
        /* ui/Size.xml:7 characters: 69-79 */
        res.autoHeight = true;
        /* ui/Size.xml:7 characters: 17-18 */
        res.w = 300;
        /* ui/Size.xml:8 characters: 13-17 */
        res.skin = get_field1();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field3():flash.events.MouseEvent -> StdTypes.Void {
        /* ui/Size.xml:10 characters: 93-98 */
        var res = function (event:flash.events.MouseEvent):StdTypes.Void {  child.widthPt = 50;  };
        return res;
    }

    inline function get_field4():ru.stablex.ui.skins.Paint {
        /* ui/Size.xml:11 characters: 19-29 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/Size.xml:11 characters: 42-47 */
        res.color = 0x00FF00;
        /* ui/Size.xml:11 characters: 31-37 */
        res.border = 1;
        return res;
    }

    inline function get_field5():ru.stablex.ui.widgets.Button {
        /* ui/Size.xml:10 characters: 9-15 */
        var res = new ru.stablex.ui.widgets.Button();
        /* ui/Size.xml:10 characters: 25-29 */
        res.text = 'Click here to set \'child.widthPt = 50\'';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_field3());
        /* ui/Size.xml:10 characters: 75-85 */
        res.autoHeight = true;
        /* ui/Size.xml:10 characters: 17-18 */
        res.w = 300;
        /* ui/Size.xml:11 characters: 13-17 */
        res.skin = get_field4();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field6():flash.events.MouseEvent -> StdTypes.Void {
        /* ui/Size.xml:13 characters: 87-92 */
        var res = function (event:flash.events.MouseEvent):StdTypes.Void {  child.h = 50;  };
        return res;
    }

    inline function get_field7():ru.stablex.ui.skins.Paint {
        /* ui/Size.xml:14 characters: 19-29 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/Size.xml:14 characters: 42-47 */
        res.color = 0x00FF00;
        /* ui/Size.xml:14 characters: 31-37 */
        res.border = 1;
        return res;
    }

    inline function get_field8():ru.stablex.ui.widgets.Button {
        /* ui/Size.xml:13 characters: 9-15 */
        var res = new ru.stablex.ui.widgets.Button();
        /* ui/Size.xml:13 characters: 25-29 */
        res.text = 'Click here to set \'child.h = 50\'';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_field6());
        /* ui/Size.xml:13 characters: 69-79 */
        res.autoHeight = true;
        /* ui/Size.xml:13 characters: 17-18 */
        res.w = 300;
        /* ui/Size.xml:14 characters: 13-17 */
        res.skin = get_field7();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field9():flash.events.MouseEvent -> StdTypes.Void {
        /* ui/Size.xml:16 characters: 94-99 */
        var res = function (event:flash.events.MouseEvent):StdTypes.Void {  child.heightPt = 50;  };
        return res;
    }

    inline function get_field10():ru.stablex.ui.skins.Paint {
        /* ui/Size.xml:17 characters: 19-29 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/Size.xml:17 characters: 42-47 */
        res.color = 0x00FF00;
        /* ui/Size.xml:17 characters: 31-37 */
        res.border = 1;
        return res;
    }

    inline function get_field11():ru.stablex.ui.widgets.Button {
        /* ui/Size.xml:16 characters: 9-15 */
        var res = new ru.stablex.ui.widgets.Button();
        /* ui/Size.xml:16 characters: 25-29 */
        res.text = 'Click here to set \'child.heightPt = 50\'';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_field9());
        /* ui/Size.xml:16 characters: 76-86 */
        res.autoHeight = true;
        /* ui/Size.xml:16 characters: 17-18 */
        res.w = 300;
        /* ui/Size.xml:17 characters: 13-17 */
        res.skin = get_field10();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field12():ru.stablex.ui.widgets.VBox {
        /* ui/Size.xml:6 characters: 5-9 */
        var res = new ru.stablex.ui.widgets.VBox();
        /* ui/Size.xml:6 characters: 37-49 */
        res.childPadding = 10;
        /* ui/Size.xml:6 characters: 55-62 */
        res.padding = 10;
        /* ui/Size.xml:6 characters: 19-29 */
        res.autoHeight = true;
        /* ui/Size.xml:6 characters: 11-12 */
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
        /* ui/Size.xml:23 characters: 15-25 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/Size.xml:23 characters: 38-43 */
        res.color = 0x005500;
        /* ui/Size.xml:23 characters: 27-33 */
        res.border = 1;
        return res;
    }

    function set_child(value:ru.stablex.ui.widgets.Widget):ru.stablex.ui.widgets.Widget {
        return child = value;
    }

    inline function get_field14():ru.stablex.ui.skins.Paint {
        /* ui/Size.xml:26 characters: 19-29 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/Size.xml:26 characters: 42-47 */
        res.color = 0x550000;
        /* ui/Size.xml:26 characters: 31-37 */
        res.border = 1;
        return res;
    }

    function get_child():ru.stablex.ui.widgets.Widget {
        /* ui/Size.xml:25 characters: 9-15 */
        if (child_initialized) return child;
        child_initialized = true;
        var res = new ru.stablex.ui.widgets.Widget();
        this.child = res;
        /* ui/Size.xml:25 characters: 27-30 */
        res.top = 50;
        /* ui/Size.xml:25 characters: 55-56 */
        res.h = 100;
        /* ui/Size.xml:25 characters: 17-21 */
        res.left = 50;
        /* ui/Size.xml:25 characters: 47-48 */
        res.w = 100;
        /* ui/Size.xml:26 characters: 13-17 */
        res.skin = get_field14();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field15():ru.stablex.ui.widgets.Widget {
        /* ui/Size.xml:22 characters: 5-11 */
        var res = new ru.stablex.ui.widgets.Widget();
        /* ui/Size.xml:22 characters: 35-36 */
        res.h = 400;
        /* ui/Size.xml:22 characters: 13-19 */
        res.bottom = 10;
        /* ui/Size.xml:22 characters: 25-29 */
        res.left = 50;
        /* ui/Size.xml:22 characters: 43-44 */
        res.w = 700;
        /* ui/Size.xml:23 characters: 9-13 */
        res.skin = get_field13();
        res._onInitialize();
        res.addChild(child);
        res._onCreate();
        return res;
    }

    public function new() {
        /* ui/Size.xml:3 characters: 1-7 */
        super();
        /* ui/Size.xml:3 characters: 17-18 */
        this.h = 600;
        /* ui/Size.xml:3 characters: 9-10 */
        this.w = 800;
        this._onInitialize();
        this.addChild(get_field12());
        this.addChild(get_field15());
        this._onCreate();
    }
}
