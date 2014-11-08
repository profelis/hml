package ;

class Index extends Main {

    var box_initialized:Bool = false;

    @:isVar public var box(get, set):ru.stablex.ui.widgets.Box;

    var nme_initialized:Bool = false;

    @:isVar public var nme(get, set):ru.stablex.ui.widgets.Box;

    var buttons_initialized:Bool = false;

    @:isVar public var buttons(get, set):ru.stablex.ui.widgets.HBox;

    var btn1_initialized:Bool = false;

    @:isVar public var btn1(get, set):ru.stablex.ui.widgets.Button;

    var btn2_initialized:Bool = false;

    @:isVar public var btn2(get, set):ru.stablex.ui.widgets.Button;

    function set_box(value:ru.stablex.ui.widgets.Box):ru.stablex.ui.widgets.Box {
        box_initialized = true;
        return box = value;
    }

    inline function get_mouseDown__0():flash.events.MouseEvent -> StdTypes.Void {
        /* assets/ui/Index.xml:14 characters: 89-98 */
        var res = function (event:flash.events.MouseEvent):StdTypes.Void { 
            nme.tween(
                1,
                {x:box.mouseX - nme.width / 2, y:box.mouseY - nme.height / 2},
                'Quad.easeOut'
            );
         };
        return res;
    }

    function set_nme(value:ru.stablex.ui.widgets.Box):ru.stablex.ui.widgets.Box {
        nme_initialized = true;
        return nme = value;
    }

    inline function get_bmp__0():ru.stablex.ui.widgets.Bmp {
        /* assets/ui/Index.xml:22 characters: 13-16 */
        var res = new ru.stablex.ui.widgets.Bmp();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Bmp")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Bmp");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* assets/ui/Index.xml:22 characters: 32-35 */
        res.src = 'assets/img/nme.png';
        /* assets/ui/Index.xml:22 characters: 18-24 */
        res.smooth = true;
        res._onInitialize();
        res._onCreate();
        return res;
    }

    function get_nme():ru.stablex.ui.widgets.Box {
        /* assets/ui/Index.xml:21 characters: 9-12 */
        if (nme_initialized) return nme;
        nme_initialized = true;
        var res = new ru.stablex.ui.widgets.Box();
        this.nme = res;
        if(ru.stablex.ui.UIBuilder.defaults.exists("Box")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Box");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* assets/ui/Index.xml:21 characters: 37-45 */
        res.skinName = 'win7';
        /* assets/ui/Index.xml:21 characters: 30-31 */
        res.h = 80;
        /* assets/ui/Index.xml:21 characters: 23-24 */
        res.w = 80;
        res._onInitialize();
        res.addChild(get_bmp__0());
        res._onCreate();
        return res;
    }

    inline function get_textFormat__0():flash.text.TextFormat {
        /* assets/ui/Index.xml:25 characters: 21-36 */
        var res = new flash.text.TextFormat();
        /* assets/ui/Index.xml:25 characters: 38-42 */
        res.size = 20;
        return res;
    }

    inline function get_text__0():ru.stablex.ui.widgets.Text {
        /* assets/ui/Index.xml:24 characters: 9-13 */
        var res = new ru.stablex.ui.widgets.Text();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Text")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Text");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* assets/ui/Index.xml:24 characters: 15-19 */
        res.text = 'Click anywhere in this box';
        /* assets/ui/Index.xml:25 characters: 13-19 */
        res.format = get_textFormat__0();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    function get_box():ru.stablex.ui.widgets.Box {
        /* assets/ui/Index.xml:14 characters: 5-8 */
        if (box_initialized) return box;
        box_initialized = true;
        var res = new ru.stablex.ui.widgets.Box();
        this.box = res;
        if(ru.stablex.ui.UIBuilder.defaults.exists("Box")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Box");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* assets/ui/Index.xml:14 characters: 70-78 */
        res.skinName = 'green';
        /* assets/ui/Index.xml:14 characters: 19-26 */
        res.rightPt = 5;
        /* assets/ui/Index.xml:14 characters: 56-64 */
        res.heightPt = 50;
        /* assets/ui/Index.xml:14 characters: 31-37 */
        res.bottom = 10;
        /* assets/ui/Index.xml:14 characters: 43-50 */
        res.widthPt = 90;
        res.addEventListener(flash.events.MouseEvent.MOUSE_DOWN, get_mouseDown__0());
        res._onInitialize();
        res.addChild(nme);
        res.addChild(get_text__0());
        res._onCreate();
        return res;
    }

    function set_buttons(value:ru.stablex.ui.widgets.HBox):ru.stablex.ui.widgets.HBox {
        buttons_initialized = true;
        return buttons = value;
    }

    inline function get_click__0():flash.events.MouseEvent -> StdTypes.Void {
        /* assets/ui/Index.xml:31 characters: 75-80 */
        var res = function (event:flash.events.MouseEvent):StdTypes.Void { 
                nme.tween(
                    1,
                    {x:box.w * Math.random(), y:box.h * Math.random()},
                    'Quad.easeIn'
                );
             };
        return res;
    }

    inline function get_button__0():ru.stablex.ui.widgets.Button {
        /* assets/ui/Index.xml:31 characters: 9-15 */
        var res = new ru.stablex.ui.widgets.Button();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Button")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* assets/ui/Index.xml:31 characters: 17-25 */
        res.skinName = 'btnxp';
        /* assets/ui/Index.xml:31 characters: 51-55 */
        res.text = 'Move nme. logo';
        /* assets/ui/Index.xml:31 characters: 44-45 */
        res.h = 40;
        res.addEventListener(flash.events.MouseEvent.CLICK, get_click__0());
        /* assets/ui/Index.xml:31 characters: 36-37 */
        res.w = 100;
        res._onInitialize();
        res._onCreate();
        return res;
    }

    function set_btn1(value:ru.stablex.ui.widgets.Button):ru.stablex.ui.widgets.Button {
        btn1_initialized = true;
        return btn1 = value;
    }

    inline function get_click__1():flash.events.MouseEvent -> StdTypes.Void {
        /* assets/ui/Index.xml:39 characters: 82-87 */
        var res = function (event:flash.events.MouseEvent):StdTypes.Void { 
                var box = this.box;
                /*
                if( cast(box.skin, ru.stablex.ui.skins.Paint).color == 0x005500 ){
                    cast(box.skin, ru.stablex.ui.skins.Paint).color       = 0x550000;
                    cast(box.skin, ru.stablex.ui.skins.Paint).borderColor = 0xFF0000;
                    btn1.text = 'Make it green';
                }else{
                    cast(box.skin, $Paint).color       = 0x005500;
                    cast(box.skin, $Paint).borderColor = 0x00ff00;
                    btn1.text = 'Make it red';
                }
                */
                if( box.skinName == 'green' ){
                    box.skinName = 'red';
                    btn1.text   = 'Make it green';
                }else{
                    box.skinName = 'green';
                    btn1.text   = 'Make it red';
                }
    
                box.applySkin();
             };
        return res;
    }

    function get_btn1():ru.stablex.ui.widgets.Button {
        /* assets/ui/Index.xml:39 characters: 9-15 */
        if (btn1_initialized) return btn1;
        btn1_initialized = true;
        var res = new ru.stablex.ui.widgets.Button();
        this.btn1 = res;
        if(ru.stablex.ui.UIBuilder.defaults.exists("Button")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* assets/ui/Index.xml:39 characters: 17-25 */
        res.skinName = 'btnxp';
        /* assets/ui/Index.xml:39 characters: 51-55 */
        res.text = 'Make it red';
        /* assets/ui/Index.xml:39 characters: 44-45 */
        res.h = 40;
        res.addEventListener(flash.events.MouseEvent.CLICK, get_click__1());
        /* assets/ui/Index.xml:39 characters: 36-37 */
        res.w = 100;
        res._onInitialize();
        res._onCreate();
        return res;
    }

    function set_btn2(value:ru.stablex.ui.widgets.Button):ru.stablex.ui.widgets.Button {
        btn2_initialized = true;
        return btn2 = value;
    }

    inline function get_click__2():flash.events.MouseEvent -> StdTypes.Void {
        /* assets/ui/Index.xml:63 characters: 85-90 */
        var res = function (event:flash.events.MouseEvent):StdTypes.Void { 
                var root = this;
                if( root.skinName == 'winxp' ){
                    root.skinName = 'winubuntu';
                    btn2.text    = 'Make it WinXP';
                }else{
                    root.skinName = 'winxp';
                    btn2.text    = 'Make it Ubuntu';
                }
                root.refresh();
    
                for(i in 0...buttons.numChildren){
                    if( Std.is(buttons.getChildAt(i), ru.stablex.ui.widgets.Button) ){
                        cast(buttons.getChildAt(i), ru.stablex.ui.widgets.Button).skinName = (root.skinName == 'winubuntu' ? 'btnubuntu' : 'btnxp');
                        cast(buttons.getChildAt(i), ru.stablex.ui.widgets.Button).refresh();
                    }
                }
            ; };
        return res;
    }

    function get_btn2():ru.stablex.ui.widgets.Button {
        /* assets/ui/Index.xml:63 characters: 9-15 */
        if (btn2_initialized) return btn2;
        btn2_initialized = true;
        var res = new ru.stablex.ui.widgets.Button();
        this.btn2 = res;
        if(ru.stablex.ui.UIBuilder.defaults.exists("Button")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* assets/ui/Index.xml:63 characters: 27-35 */
        res.skinName = 'btnxp';
        /* assets/ui/Index.xml:63 characters: 61-65 */
        res.text = 'Make it Ubuntu';
        /* assets/ui/Index.xml:63 characters: 54-55 */
        res.h = 40;
        res.addEventListener(flash.events.MouseEvent.CLICK, get_click__2());
        /* assets/ui/Index.xml:63 characters: 46-47 */
        res.w = 100;
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_click__3():flash.events.MouseEvent -> StdTypes.Void {
        /* assets/ui/Index.xml:82 characters: 74-79 */
        var res = function (event:flash.events.MouseEvent):StdTypes.Void { 
                resize(500 + Std.random(291), 400 + Std.random(191));
             };
        return res;
    }

    inline function get_button__1():ru.stablex.ui.widgets.Button {
        /* assets/ui/Index.xml:82 characters: 9-15 */
        var res = new ru.stablex.ui.widgets.Button();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Button")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* assets/ui/Index.xml:82 characters: 17-25 */
        res.skinName = 'btnxp';
        /* assets/ui/Index.xml:82 characters: 51-55 */
        res.text = 'Random resize';
        /* assets/ui/Index.xml:82 characters: 44-45 */
        res.h = 40;
        res.addEventListener(flash.events.MouseEvent.CLICK, get_click__3());
        /* assets/ui/Index.xml:82 characters: 36-37 */
        res.w = 100;
        res._onInitialize();
        res._onCreate();
        return res;
    }

    function get_buttons():ru.stablex.ui.widgets.HBox {
        /* assets/ui/Index.xml:30 characters: 5-9 */
        if (buttons_initialized) return buttons;
        buttons_initialized = true;
        var res = new ru.stablex.ui.widgets.HBox();
        this.buttons = res;
        if(ru.stablex.ui.UIBuilder.defaults.exists("HBox")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("HBox");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* assets/ui/Index.xml:30 characters: 24-27 */
        res.top = 35;
        /* assets/ui/Index.xml:30 characters: 54-66 */
        res.childPadding = 10;
        /* assets/ui/Index.xml:30 characters: 72-77 */
        res.align = 'center,middle';
        /* assets/ui/Index.xml:30 characters: 47-48 */
        res.h = 40;
        /* assets/ui/Index.xml:30 characters: 33-40 */
        res.widthPt = 100;
        res._onInitialize();
        res.addChild(get_button__0());
        res.addChild(btn1);
        res.addChild(btn2);
        res.addChild(get_button__1());
        res._onCreate();
        return res;
    }

    public function new() {
        /* assets/ui/Index.xml:4 characters: 1-10 */
        super();
        /* assets/ui/Index.xml:11 characters: 7-15 */
        this.skinName = 'winxp';
        /* assets/ui/Index.xml:10 characters: 14-15 */
        this.h = flash.Lib.current.stage.stageHeight - 20;
        /* assets/ui/Index.xml:7 characters: 14-15 */
        this.x = 10;
        /* assets/ui/Index.xml:9 characters: 14-15 */
        this.w = flash.Lib.current.stage.stageWidth - 20;
        /* assets/ui/Index.xml:8 characters: 14-15 */
        this.y = 10;
        this._onInitialize();
        this.addChild(box);
        this.addChild(buttons);
        this._onCreate();
    }
}
