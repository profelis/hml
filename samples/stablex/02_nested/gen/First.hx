package ;

class First extends ru.stablex.ui.widgets.Widget {

    inline function get_field0():ru.stablex.ui.skins.Paint {
        /* ui/First.xml:6 characters: 3-13 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/First.xml:7 characters: 4-15 */
        res.border = 1;
        return res;
    }

    inline function get_field1():ru.stablex.ui.widgets.Text {
        /* ui/First.xml:10 characters: 5-9 */
        var res = new ru.stablex.ui.widgets.Text();
        /* ui/First.xml:10 characters: 21-24 */
        res.top = 100;
        /* ui/First.xml:10 characters: 31-35 */
        res.text = 'My first widget!';
        /* ui/First.xml:10 characters: 11-15 */
        res.left = 50;
        res._onInitialize();
        res._onCreate();
        return res;
    }

    public function new() {
        /* ui/First.xml:4 characters: 1-7 */
        super();
        /* ui/First.xml:4 characters: 65-68 */
        this.top = 100;
        /* ui/First.xml:4 characters: 47-48 */
        this.h = 400;
        /* ui/First.xml:4 characters: 55-59 */
        this.left = 50;
        /* ui/First.xml:4 characters: 39-40 */
        this.w = 400;
        /* ui/First.xml:5 characters: 2-6 */
        this.skin = get_field0();
        this._onInitialize();
        this.addChild(get_field1());
        this._onCreate();
    }
}
