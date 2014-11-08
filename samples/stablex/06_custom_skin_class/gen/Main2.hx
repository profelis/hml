package ;

class Main2 extends ru.stablex.ui.widgets.Widget {

    inline function get_fractal__0():Fractal {
        /* ui/Main2.xml:4 characters: 8-20 */
        var res = new Fractal();
        /* ui/Main2.xml:4 characters: 22-35 */
        res.lineThickness = 8;
        /* ui/Main2.xml:4 characters: 40-49 */
        res.lineColor = 0x00FF00;
        /* ui/Main2.xml:4 characters: 61-65 */
        res.step = 20;
        return res;
    }

    public function new() {
        /* ui/Main2.xml:3 characters: 1-7 */
        super();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Widget")) {
        	var defFns = ru.stablex.ui.UIBuilder.defaults.get("Widget");
        	for(def in ["Default"]) {
        		var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
        		if(defaultsFn != null) defaultsFn(this);
        	}
        }
        /* ui/Main2.xml:3 characters: 61-62 */
        this.h = 200;
        /* ui/Main2.xml:3 characters: 53-54 */
        this.w = 400;
        /* ui/Main2.xml:4 characters: 2-6 */
        this.skin = get_fractal__0();
        this._onInitialize();
        this._onCreate();
    }
}
