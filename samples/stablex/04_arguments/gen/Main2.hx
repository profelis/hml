package ;

class Main2 extends ru.stablex.ui.widgets.HBox {

    var input_initialized:Bool = false;

    @:isVar public var input(get, set):ru.stablex.ui.widgets.InputText;

    public function destroyHml():Void {
        
    }
    

    function set_input(value:ru.stablex.ui.widgets.InputText):ru.stablex.ui.widgets.InputText {
        input_initialized = true;
        return input = value;
    }

    inline function get_paint__0():ru.stablex.ui.skins.Paint {
        /* ui/Main2.xml:5 characters: 12-22 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/Main2.xml:5 characters: 24-30 */
        res.border = 1;
        /* ui/Main2.xml:5 characters: 35-40 */
        res.color = 0xFFFFFF;
        return res;
    }

    function get_input():ru.stablex.ui.widgets.InputText {
        /* ui/Main2.xml:4 characters: 5-14 */
        if (input_initialized) return input;
        input_initialized = true;
        this.input = new ru.stablex.ui.widgets.InputText();
        var res = this.input;
        if(ru.stablex.ui.UIBuilder.defaults.exists("InputText")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("InputText");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Main2.xml:4 characters: 35-36 */
        res.h = 20;
        /* ui/Main2.xml:4 characters: 42-46 */
        res.text = 'type any message here';
        /* ui/Main2.xml:4 characters: 27-28 */
        res.w = 150;
        /* ui/Main2.xml:5 characters: 6-10 */
        res.skin = get_paint__0();
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_click__0():flash.events.MouseEvent -> StdTypes.Void {
        /* ui/Main2.xml:9 characters: 48-53 */
        var res = function (event:flash.events.MouseEvent):StdTypes.Void { 
            flash.Lib.current.addChild(
                {
                    var alert = new Alert();
                    alert.message.text = input.text;
                    alert;
                }
            );
         };
        return res;
    }

    inline function get_paint__1():ru.stablex.ui.skins.Paint {
        /* ui/Main2.xml:18 characters: 12-22 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/Main2.xml:18 characters: 24-30 */
        res.border = 1;
        /* ui/Main2.xml:18 characters: 35-40 */
        res.color = 0xbbbbbb;
        return res;
    }

    inline function get_button__0():ru.stablex.ui.widgets.Button {
        /* ui/Main2.xml:9 characters: 5-11 */
        var res = new ru.stablex.ui.widgets.Button();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Button")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(res);
            }
        }
        /* ui/Main2.xml:9 characters: 13-14 */
        res.h = 20;
        /* ui/Main2.xml:9 characters: 20-24 */
        res.text = 'Show me the alert!';
        res.addEventListener(flash.events.MouseEvent.CLICK, get_click__0());
        /* ui/Main2.xml:18 characters: 6-10 */
        res.skin = get_paint__1();
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
        this.childPadding = 5;
        /* ui/Main2.xml:3 characters: 7-14 */
        this.padding = 10;
        this._onInitialize();
        this.addChild(input);
        this.addChild(get_button__0());
        this._onCreate();
    }
}
