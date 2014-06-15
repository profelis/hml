package ;

class GreenButton extends ru.stablex.ui.widgets.Button {

    inline function get_field2():ru.stablex.ui.skins.Paint {
        var res = new ru.stablex.ui.skins.Paint();
        res.color = 0x00FF00;
        res.border = 2;
        res.corners = [5];
        return res;
    }

    public function new() {
        super();
        this.heightPt = 15;
        this.skin = get_field2();
        this._onInitialize();
        this._onCreate();
    }
}
