package ;

class First extends ru.stablex.ui.widgets.Widget {

    inline function get_field0():ru.stablex.ui.skins.Paint {
        var res = new ru.stablex.ui.skins.Paint();
        res.border = 1;
        return res;
    }

    inline function get_field1():ru.stablex.ui.widgets.Text {
        var res = new ru.stablex.ui.widgets.Text();
        res.top = 100;
        res.text = 'My first widget!';
        res.left = 50;
        res._onInitialize();
        res._onCreate();
        return res;
    }

    public function new() {
        super();
        this.top = 100;
        this.h = 400;
        this.left = 50;
        this.w = 400;
        this.skin = get_field0();
        this._onInitialize();
        this.addChild(get_field1());
        this._onCreate();
    }
}
