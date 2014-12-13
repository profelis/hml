package ;

class Position extends ru.stablex.ui.widgets.Widget {

    var child_initialized:Bool = false;

    @:isVar public var child(get, set):ru.stablex.ui.widgets.Widget;

    public function destroyHml():Void {
        
    }
    

    inline function get_click__0():flash.events.MouseEvent -> StdTypes.Void {
        /* ui/Position.xml:7 characters: 90-95 */
        var res = function (event:flash.events.MouseEvent):StdTypes.Void {  child.left = 30 ; };
        return res;
    }

    inline function get_paint__0():ru.stablex.ui.skins.Paint {
        /* ui/Position.xml:8 characters: 19-29 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/Position.xml:8 characters: 42-47 */
        res.color = 0x00FF00;
        /* ui/Position.xml:8 characters: 31-37 */
        res.border = 1;
        return res;
    }

    inline function get_button__0():ru.stablex.ui.widgets.Button {
        /* ui/Position.xml:7 characters: 9-15 */
        var res = new ru.stablex.ui.widgets.Button();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Button")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Position.xml:7 characters: 25-29 */
        res.text = 'Click here to set \'child.left = 30\'';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_click__0());
        /* ui/Position.xml:7 characters: 72-82 */
        res.autoHeight = true;
        /* ui/Position.xml:7 characters: 17-18 */
        res.w = 300;
        /* ui/Position.xml:8 characters: 13-17 */
        res.skin = get_paint__0();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_click__1():flash.events.MouseEvent -> StdTypes.Void {
        /* ui/Position.xml:10 characters: 92-97 */
        var res = function (event:flash.events.MouseEvent):StdTypes.Void {  child.leftPt = 30;  };
        return res;
    }

    inline function get_paint__1():ru.stablex.ui.skins.Paint {
        /* ui/Position.xml:11 characters: 19-29 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/Position.xml:11 characters: 42-47 */
        res.color = 0x00FF00;
        /* ui/Position.xml:11 characters: 31-37 */
        res.border = 1;
        return res;
    }

    inline function get_button__1():ru.stablex.ui.widgets.Button {
        /* ui/Position.xml:10 characters: 9-15 */
        var res = new ru.stablex.ui.widgets.Button();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Button")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Position.xml:10 characters: 25-29 */
        res.text = 'Click here to set \'child.leftPt = 30\'';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_click__1());
        /* ui/Position.xml:10 characters: 74-84 */
        res.autoHeight = true;
        /* ui/Position.xml:10 characters: 17-18 */
        res.w = 300;
        /* ui/Position.xml:11 characters: 13-17 */
        res.skin = get_paint__1();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_click__2():flash.events.MouseEvent -> StdTypes.Void {
        /* ui/Position.xml:13 characters: 91-96 */
        var res = function (event:flash.events.MouseEvent):StdTypes.Void {  child.right = 30;  };
        return res;
    }

    inline function get_paint__2():ru.stablex.ui.skins.Paint {
        /* ui/Position.xml:15 characters: 19-29 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/Position.xml:15 characters: 42-47 */
        res.color = 0x00FF00;
        /* ui/Position.xml:15 characters: 31-37 */
        res.border = 1;
        return res;
    }

    inline function get_button__2():ru.stablex.ui.widgets.Button {
        /* ui/Position.xml:13 characters: 9-15 */
        var res = new ru.stablex.ui.widgets.Button();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Button")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Position.xml:13 characters: 25-29 */
        res.text = 'Click here to set \'child.right = 30\'';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_click__2());
        /* ui/Position.xml:13 characters: 73-83 */
        res.autoHeight = true;
        /* ui/Position.xml:13 characters: 17-18 */
        res.w = 300;
        /* ui/Position.xml:15 characters: 13-17 */
        res.skin = get_paint__2();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_click__3():flash.events.MouseEvent -> StdTypes.Void {
        /* ui/Position.xml:17 characters: 93-98 */
        var res = function (event:flash.events.MouseEvent):StdTypes.Void {  child.rightPt = 30;  };
        return res;
    }

    inline function get_paint__3():ru.stablex.ui.skins.Paint {
        /* ui/Position.xml:18 characters: 19-29 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/Position.xml:18 characters: 42-47 */
        res.color = 0x00FF00;
        /* ui/Position.xml:18 characters: 31-37 */
        res.border = 1;
        return res;
    }

    inline function get_button__3():ru.stablex.ui.widgets.Button {
        /* ui/Position.xml:17 characters: 9-15 */
        var res = new ru.stablex.ui.widgets.Button();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Button")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Position.xml:17 characters: 25-29 */
        res.text = 'Click here to set \'child.rightPt = 30\'';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_click__3());
        /* ui/Position.xml:17 characters: 75-85 */
        res.autoHeight = true;
        /* ui/Position.xml:17 characters: 17-18 */
        res.w = 300;
        /* ui/Position.xml:18 characters: 13-17 */
        res.skin = get_paint__3();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_click__4():flash.events.MouseEvent -> StdTypes.Void {
        /* ui/Position.xml:20 characters: 89-94 */
        var res = function (event:flash.events.MouseEvent):StdTypes.Void {  child.top = 30;  };
        return res;
    }

    inline function get_paint__4():ru.stablex.ui.skins.Paint {
        /* ui/Position.xml:21 characters: 19-29 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/Position.xml:21 characters: 42-47 */
        res.color = 0x00FF00;
        /* ui/Position.xml:21 characters: 31-37 */
        res.border = 1;
        return res;
    }

    inline function get_button__4():ru.stablex.ui.widgets.Button {
        /* ui/Position.xml:20 characters: 9-15 */
        var res = new ru.stablex.ui.widgets.Button();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Button")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Position.xml:20 characters: 25-29 */
        res.text = 'Click here to set \'child.top = 30\'';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_click__4());
        /* ui/Position.xml:20 characters: 71-81 */
        res.autoHeight = true;
        /* ui/Position.xml:20 characters: 17-18 */
        res.w = 300;
        /* ui/Position.xml:21 characters: 13-17 */
        res.skin = get_paint__4();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_click__5():flash.events.MouseEvent -> StdTypes.Void {
        /* ui/Position.xml:23 characters: 91-96 */
        var res = function (event:flash.events.MouseEvent):StdTypes.Void {  child.topPt = 30;  };
        return res;
    }

    inline function get_paint__5():ru.stablex.ui.skins.Paint {
        /* ui/Position.xml:24 characters: 19-29 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/Position.xml:24 characters: 42-47 */
        res.color = 0x00FF00;
        /* ui/Position.xml:24 characters: 31-37 */
        res.border = 1;
        return res;
    }

    inline function get_button__5():ru.stablex.ui.widgets.Button {
        /* ui/Position.xml:23 characters: 9-15 */
        var res = new ru.stablex.ui.widgets.Button();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Button")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Position.xml:23 characters: 25-29 */
        res.text = 'Click here to set \'child.topPt = 30\'';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_click__5());
        /* ui/Position.xml:23 characters: 73-83 */
        res.autoHeight = true;
        /* ui/Position.xml:23 characters: 17-18 */
        res.w = 300;
        /* ui/Position.xml:24 characters: 13-17 */
        res.skin = get_paint__5();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_click__6():flash.events.MouseEvent -> StdTypes.Void {
        /* ui/Position.xml:26 characters: 92-97 */
        var res = function (event:flash.events.MouseEvent):StdTypes.Void {  child.bottom = 30;  };
        return res;
    }

    inline function get_paint__6():ru.stablex.ui.skins.Paint {
        /* ui/Position.xml:27 characters: 19-29 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/Position.xml:27 characters: 42-47 */
        res.color = 0x00FF00;
        /* ui/Position.xml:27 characters: 31-37 */
        res.border = 1;
        return res;
    }

    inline function get_button__6():ru.stablex.ui.widgets.Button {
        /* ui/Position.xml:26 characters: 9-15 */
        var res = new ru.stablex.ui.widgets.Button();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Button")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Position.xml:26 characters: 25-29 */
        res.text = 'Click here to set \'child.bottom = 30\'';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_click__6());
        /* ui/Position.xml:26 characters: 74-84 */
        res.autoHeight = true;
        /* ui/Position.xml:26 characters: 17-18 */
        res.w = 300;
        /* ui/Position.xml:27 characters: 13-17 */
        res.skin = get_paint__6();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_click__7():flash.events.MouseEvent -> StdTypes.Void {
        /* ui/Position.xml:29 characters: 94-99 */
        var res = function (event:flash.events.MouseEvent):StdTypes.Void {  child.bottomPt = 30;  };
        return res;
    }

    inline function get_paint__7():ru.stablex.ui.skins.Paint {
        /* ui/Position.xml:30 characters: 19-29 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/Position.xml:30 characters: 42-47 */
        res.color = 0x00FF00;
        /* ui/Position.xml:30 characters: 31-37 */
        res.border = 1;
        return res;
    }

    inline function get_button__7():ru.stablex.ui.widgets.Button {
        /* ui/Position.xml:29 characters: 9-15 */
        var res = new ru.stablex.ui.widgets.Button();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Button")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Position.xml:29 characters: 25-29 */
        res.text = 'Click here to set \'child.bottomPt = 30\'';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_click__7());
        /* ui/Position.xml:29 characters: 76-86 */
        res.autoHeight = true;
        /* ui/Position.xml:29 characters: 17-18 */
        res.w = 300;
        /* ui/Position.xml:30 characters: 13-17 */
        res.skin = get_paint__7();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_vBox__0():ru.stablex.ui.widgets.VBox {
        /* ui/Position.xml:6 characters: 5-9 */
        var res = new ru.stablex.ui.widgets.VBox();
        if(ru.stablex.ui.UIBuilder.defaults.exists("VBox")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("VBox");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Position.xml:6 characters: 19-31 */
        res.childPadding = 10;
        /* ui/Position.xml:6 characters: 37-44 */
        res.padding = 10;
        /* ui/Position.xml:6 characters: 11-12 */
        res.w = 800;
        res._onInitialize();
        res.addChild(get_button__0());
        res.addChild(get_button__1());
        res.addChild(get_button__2());
        res.addChild(get_button__3());
        res.addChild(get_button__4());
        res.addChild(get_button__5());
        res.addChild(get_button__6());
        res.addChild(get_button__7());
        res._onCreate();
        return res;
    }

    inline function get_paint__8():ru.stablex.ui.skins.Paint {
        /* ui/Position.xml:36 characters: 15-25 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/Position.xml:36 characters: 38-43 */
        res.color = 0x005500;
        /* ui/Position.xml:36 characters: 27-33 */
        res.border = 1;
        return res;
    }

    function set_child(value:ru.stablex.ui.widgets.Widget):ru.stablex.ui.widgets.Widget {
        child_initialized = true;
        return child = value;
    }

    inline function get_paint__9():ru.stablex.ui.skins.Paint {
        /* ui/Position.xml:39 characters: 19-29 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/Position.xml:39 characters: 42-47 */
        res.color = 0x550000;
        /* ui/Position.xml:39 characters: 31-37 */
        res.border = 1;
        return res;
    }

    function get_child():ru.stablex.ui.widgets.Widget {
        /* ui/Position.xml:38 characters: 9-15 */
        if (child_initialized) return child;
        child_initialized = true;
        this.child = new ru.stablex.ui.widgets.Widget();
        var res = this.child;
        if(ru.stablex.ui.UIBuilder.defaults.exists("Widget")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Widget");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Position.xml:38 characters: 57-58 */
        res.h = 50;
        /* ui/Position.xml:38 characters: 28-33 */
        res.topPt = 50;
        /* ui/Position.xml:38 characters: 17-21 */
        res.leftPt = 50;
        /* ui/Position.xml:38 characters: 50-51 */
        res.w = 50;
        /* ui/Position.xml:39 characters: 13-17 */
        res.skin = get_paint__9();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_widget__0():ru.stablex.ui.widgets.Widget {
        /* ui/Position.xml:35 characters: 5-11 */
        var res = new ru.stablex.ui.widgets.Widget();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Widget")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Widget");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Position.xml:35 characters: 35-36 */
        res.h = 300;
        /* ui/Position.xml:35 characters: 13-19 */
        res.bottom = 10;
        /* ui/Position.xml:35 characters: 25-29 */
        res.left = 50;
        /* ui/Position.xml:35 characters: 43-44 */
        res.w = 700;
        /* ui/Position.xml:36 characters: 9-13 */
        res.skin = get_paint__8();
        res._onInitialize();
        res.addChild(child);
        res._onCreate();
        return res;
    }

    public function new() {
        /* ui/Position.xml:3 characters: 1-7 */
        super();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Widget")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Widget");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(this);
            }
        }
        /* ui/Position.xml:3 characters: 17-18 */
        this.h = 600;
        /* ui/Position.xml:3 characters: 9-10 */
        this.w = 800;
        this._onInitialize();
        this.addChild(get_vBox__0());
        this.addChild(get_widget__0());
        this._onCreate();
    }
}
