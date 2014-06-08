package ;

class First extends ru.stablex.ui.widgets.Box {

    @:expose inline function get_field2():ru.stablex.ui.skins.Paint {
        var res = new ru.stablex.ui.skins.Paint();
        res.color = 0xFF0000;
        res.border = 2;
        res.corners = [20];
        if (Std.is(res, ru.stablex.ui.widgets.Widget)) {
            var w:ru.stablex.ui.widgets.Widget = cast res;
            ru.stablex.ui.UIBuilder.applyDefaults(w);
            w.onInitialize();
            w.onCreate();
        }
        return res;
    }

    @:expose inline function get_field0():ru.stablex.ui.widgets.Button {
        var res = new ru.stablex.ui.widgets.Button();
        res.top = 100;
        res.text = 'My first widget!';
        res.left = 50;
        res.skin = get_field2();
        res.onInitialize();
        res.onCreate();
        return res;
    }

    @:expose inline function get_field3():ru.stablex.ui.widgets.Text {
        var res = new ru.stablex.ui.widgets.Text();
        res.top = 150;
        res.text = 'My second widget!';
        res.left = 50;
        res.onInitialize();
        res.onCreate();
        return res;
    }

    public function new() {
        super();
        this.addChild(get_field0());
        this.addChild(get_field3());
        this.onInitialize();
        this.onCreate();
    }
}