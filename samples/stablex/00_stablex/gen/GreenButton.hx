package ;

class GreenButton extends ru.stablex.ui.widgets.Button {

    public function destroyHml():Void {
        
    }
    

    inline function get_paint__0():ru.stablex.ui.skins.Paint {
        /* ui/GreenButton.xml:5 characters: 3-13 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/GreenButton.xml:5 characters: 32-38 */
        res.border = 2;
        /* ui/GreenButton.xml:5 characters: 15-20 */
        res.color = 0x00FF00;
        /* ui/GreenButton.xml:5 characters: 43-50 */
        res.corners = [5];
        return res;
    }

    public function new() {
        /* ui/GreenButton.xml:3 characters: 1-15 */
        super();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Button")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Button");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(this);
            }
        }
        /* ui/GreenButton.xml:3 characters: 88-89 */
        this.heightPt = 15;
        /* ui/GreenButton.xml:3 characters: 96-106 */
        this.id = 'testId';
        /* ui/GreenButton.xml:4 characters: 2-14 */
        this.skin = get_paint__0();
        this._onInitialize();
        this._onCreate();
    }
}
