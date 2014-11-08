package ;

class First extends ru.stablex.ui.widgets.Text {

    public function new() {
        /* ui/First.xml:3 characters: 1-5 */
        super();
        if(ru.stablex.ui.UIBuilder.defaults.exists("Text")) {
            var defFns = ru.stablex.ui.UIBuilder.defaults.get("Text");
            for(def in ["Default"]) {
                var defaultsFn:ru.stablex.ui.widgets.Widget->Void = defFns.get(def);
                if(defaultsFn != null) defaultsFn(this);
            }
        }
        /* ui/First.xml:3 characters: 49-52 */
        this.top = 100;
        /* ui/First.xml:3 characters: 59-63 */
        this.text = 'My first widget!';
        /* ui/First.xml:3 characters: 39-43 */
        this.left = 50;
        this._onInitialize();
        this._onCreate();
    }
}
