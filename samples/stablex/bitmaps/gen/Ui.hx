package ;

class Ui extends ru.stablex.ui.widgets.VBox {

    public function destroyHml():Void {
        
    }
    

    inline function get_paint__0():ru.stablex.ui.skins.Paint {
        /* ui/Ui.xml:8 characters: 13-23 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/Ui.xml:8 characters: 25-30 */
        res.color = 0x555555;
        return res;
    }

    inline function get_bmp__0():ru.stablex.ui.widgets.Bmp {
        /* ui/Ui.xml:12 characters: 9-12 */
        var res = new ru.stablex.ui.widgets.Bmp();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Bmp")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Bmp");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Ui.xml:12 characters: 14-17 */
        res.src = 'assets/haxe.png';
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_bmp__1():ru.stablex.ui.widgets.Bmp {
        /* ui/Ui.xml:15 characters: 9-12 */
        var res = new ru.stablex.ui.widgets.Bmp();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Bmp")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Bmp");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Ui.xml:15 characters: 14-17 */
        res.src = 'assets/haxe.png';
        /* ui/Ui.xml:15 characters: 71-72 */
        res.h = 76;
        /* ui/Ui.xml:15 characters: 38-45 */
        res.xOffset = 72;
        /* ui/Ui.xml:15 characters: 51-58 */
        res.yOffset = 72;
        /* ui/Ui.xml:15 characters: 64-65 */
        res.w = 76;
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_bmp__2():ru.stablex.ui.widgets.Bmp {
        /* ui/Ui.xml:18 characters: 9-12 */
        var res = new ru.stablex.ui.widgets.Bmp();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Bmp")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Bmp");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Ui.xml:18 characters: 62-71 */
        res.autoWidth = true;
        /* ui/Ui.xml:18 characters: 14-17 */
        res.src = 'assets/haxe.png';
        /* ui/Ui.xml:18 characters: 79-80 */
        res.h = 148;
        /* ui/Ui.xml:18 characters: 38-45 */
        res.xOffset = 0;
        /* ui/Ui.xml:18 characters: 50-57 */
        res.yOffset = 0;
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_hBox__0():ru.stablex.ui.widgets.HBox {
        /* ui/Ui.xml:6 characters: 5-9 */
        var res = new ru.stablex.ui.widgets.HBox();
        if(ru.stablex.ui.UIBuilder.defaults.exists("HBox")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("HBox");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Ui.xml:6 characters: 24-36 */
        res.childPadding = 30;
        /* ui/Ui.xml:6 characters: 11-18 */
        res.padding = 50;
        /* ui/Ui.xml:6 characters: 42-43 */
        res.widthPt = 100;
        /* ui/Ui.xml:7 characters: 9-13 */
        res.skin = get_paint__0();
        res._onInitialize();
        res.addChild(get_bmp__0());
        res.addChild(get_bmp__1());
        res.addChild(get_bmp__2());
        res._onCreate();
        return res;
    }

    inline function get_paint__1():ru.stablex.ui.skins.Paint {
        /* ui/Ui.xml:24 characters: 13-23 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/Ui.xml:24 characters: 25-30 */
        res.color = 0x555555;
        return res;
    }

    inline function get_bmp__3():ru.stablex.ui.widgets.Bmp {
        /* ui/Ui.xml:27 characters: 9-12 */
        var res = new ru.stablex.ui.widgets.Bmp();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Bmp")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Bmp");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Ui.xml:27 characters: 14-17 */
        res.src = 'assets/haxe.png';
        /* ui/Ui.xml:27 characters: 46-47 */
        res.h = 100;
        /* ui/Ui.xml:27 characters: 38-39 */
        res.w = 100;
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_bmp__4():ru.stablex.ui.widgets.Bmp {
        /* ui/Ui.xml:29 characters: 9-12 */
        var res = new ru.stablex.ui.widgets.Bmp();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Bmp")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Bmp");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Ui.xml:29 characters: 14-17 */
        res.src = 'assets/haxe.png';
        /* ui/Ui.xml:29 characters: 46-47 */
        res.h = 100;
        /* ui/Ui.xml:29 characters: 38-39 */
        res.w = 100;
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_hBox__1():ru.stablex.ui.widgets.HBox {
        /* ui/Ui.xml:22 characters: 5-9 */
        var res = new ru.stablex.ui.widgets.HBox();
        if(ru.stablex.ui.UIBuilder.defaults.exists("HBox")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("HBox");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Ui.xml:22 characters: 24-36 */
        res.childPadding = 30;
        /* ui/Ui.xml:22 characters: 11-18 */
        res.padding = 50;
        /* ui/Ui.xml:22 characters: 42-43 */
        res.widthPt = 100;
        /* ui/Ui.xml:23 characters: 9-13 */
        res.skin = get_paint__1();
        res._onInitialize();
        res.addChild(get_bmp__3());
        res.addChild(get_bmp__4());
        res._onCreate();
        return res;
    }

    public function new() {
        /* ui/Ui.xml:3 characters: 1-5 */
        super();
        if(ru.stablex.ui.UIBuilder.defaults.exists("VBox")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("VBox");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(this);
            }
        }
        /* ui/Ui.xml:3 characters: 109-110 */
        this.h = flash.Lib.current.stage.stageHeight;
        /* ui/Ui.xml:3 characters: 70-71 */
        this.w = flash.Lib.current.stage.stageWidth;
        this._onInitialize();
        this.addChild(get_hBox__0());
        this.addChild(get_hBox__1());
        this._onCreate();
    }
}
