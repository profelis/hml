package ;

class Main2 extends ru.stablex.ui.widgets.HBox {

    var custom_initialized:Bool = false;

    @:isVar public var custom(get, set):ColorWidget;

    public function destroyHml():Void {
        
    }
    

    function set_custom(value:ColorWidget):ColorWidget {
        custom_initialized = true;
        return custom = value;
    }

    function get_custom():ColorWidget {
        /* ui/Main2.xml:4 characters: 5-16 */
        if (custom_initialized) return custom;
        custom_initialized = true;
        this.custom = new ColorWidget();
        var res = this.custom;
        /* ui/Main2.xml:4 characters: 55-60 */
        res.color = 0x0000FF;
        /* ui/Main2.xml:4 characters: 47-48 */
        res.h = 100;
        /* ui/Main2.xml:4 characters: 39-40 */
        res.w = 200;
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_click__0():flash.events.MouseEvent -> StdTypes.Void {
        /* ui/Main2.xml:5 characters: 39-44 */
        var res = function (event:flash.events.MouseEvent):StdTypes.Void { 
            custom.color = Std.random(0xFFFFFF);
            custom.refresh();
         };
        return res;
    }

    inline function get_paint__0():ru.stablex.ui.skins.Paint {
        /* ui/Main2.xml:9 characters: 11-21 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/Main2.xml:9 characters: 23-28 */
        res.color = 0x999999;
        return res;
    }

    inline function get_button__0():ru.stablex.ui.widgets.Button {
        /* ui/Main2.xml:5 characters: 5-11 */
        var res = new ru.stablex.ui.widgets.Button();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Button")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Main2.xml:5 characters: 13-17 */
        res.text = 'set random color';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_click__0());
        /* ui/Main2.xml:9 characters: 5-9 */
        res.skin = get_paint__0();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    public function new() {
        /* ui/Main2.xml:3 characters: 1-5 */
        super();
        if(ru.stablex.ui.UIBuilder.defaults.exists("HBox")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("HBox");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(this);
            }
        }
        /* ui/Main2.xml:3 characters: 20-32 */
        this.childPadding = 20;
        /* ui/Main2.xml:3 characters: 7-14 */
        this.padding = 20;
        this._onInitialize();
        this.addChild(custom);
        this.addChild(get_button__0());
        this._onCreate();
    }
}
