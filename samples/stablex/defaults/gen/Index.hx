package ;

class Index extends ru.stablex.ui.widgets.VBox {

    public function destroyHml():Void {
        
    }
    

    inline function get_paint__0():ru.stablex.ui.skins.Paint {
        /* ui/Index.xml:6 characters: 4-14 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/Index.xml:6 characters: 16-21 */
        res.color = 0x005d00;
        /* ui/Index.xml:6 characters: 68-74 */
        res.border = 8;
        /* ui/Index.xml:6 characters: 56-61 */
        res.alpha = 0.8;
        /* ui/Index.xml:6 characters: 33-44 */
        res.borderColor = 0x003a00;
        return res;
    }

    inline function get_text__0():ru.stablex.ui.widgets.Text {
        /* ui/Index.xml:8 characters: 5-9 */
        var res = new ru.stablex.ui.widgets.Text();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Text")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Text");
            for(def in ["Title"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Index.xml:8 characters: 30-34 */
        res.text = 'This text is using `Title` defaults';
        /* ui/Index.xml:8 characters: 11-19 */
        res.defaults = 'Title';
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_text__1():ru.stablex.ui.widgets.Text {
        /* ui/Index.xml:9 characters: 5-9 */
        var res = new ru.stablex.ui.widgets.Text();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Text")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Text");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Index.xml:9 characters: 11-15 */
        res.text = 'This is text with no defaults specified. And `Default` section for Text tag is not defined in defaults.xml';
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_text__2():ru.stablex.ui.widgets.Text {
        /* ui/Index.xml:10 characters: 5-9 */
        var res = new ru.stablex.ui.widgets.Text();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Text")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Text");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Index.xml:10 characters: 11-15 */
        res.text = 'So this text looks like it was just `new flash.text.TextField()` ';
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_button__0():ru.stablex.ui.widgets.Button {
        /* ui/Index.xml:11 characters: 5-11 */
        var res = new ru.stablex.ui.widgets.Button();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Button")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Index.xml:11 characters: 13-17 */
        res.text = 'this is button with no defaults specified. But `Default` section for buttons does exist in defaults.xml';
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_button__1():ru.stablex.ui.widgets.Button {
        /* ui/Index.xml:12 characters: 5-11 */
        var res = new ru.stablex.ui.widgets.Button();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Button")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
            for(def in ["Red"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Index.xml:12 characters: 28-32 */
        res.text = 'this button is using `Red` section for buttons in defaults.xml';
        /* ui/Index.xml:12 characters: 13-21 */
        res.defaults = 'Red';
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_button__2():ru.stablex.ui.widgets.Button {
        /* ui/Index.xml:13 characters: 5-11 */
        var res = new ru.stablex.ui.widgets.Button();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Button")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
            for(def in ["Red", "AnotherFormat"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Index.xml:13 characters: 43-47 */
        res.text = 'this button is using `Red` and `AnotherFormat` sections for buttons in defaults.xml';
        /* ui/Index.xml:13 characters: 13-21 */
        res.defaults = 'Red, AnotherFormat';
        res._onInitialize();
        res._onCreate();
        return res;
    }

    public function new() {
        /* ui/Index.xml:4 characters: 1-5 */
        super();
        if(ru.stablex.ui.UIBuilder.defaults.exists("VBox")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("VBox");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(this);
            }
        }
        /* ui/Index.xml:4 characters: 7-11 */
        this.name = 'top';
        /* ui/Index.xml:4 characters: 99-111 */
        this.childPadding = 20;
        /* ui/Index.xml:4 characters: 28-29 */
        this.h = 600;
        /* ui/Index.xml:4 characters: 20-21 */
        this.w = 800;
        /* ui/Index.xml:5 characters: 3-7 */
        this.skin = get_paint__0();
        this._onInitialize();
        this.addChild(get_text__0());
        this.addChild(get_text__1());
        this.addChild(get_text__2());
        this.addChild(get_button__0());
        this.addChild(get_button__1());
        this.addChild(get_button__2());
        this._onCreate();
    }
}
