package ;

class GreenButton extends ru.stablex.ui.widgets.Button {

    inline function get_field1():String {
        var res = 'testId';
        return res;
    }

    inline function get_field3():ru.stablex.ui.skins.Paint {
        var res = new ru.stablex.ui.skins.Paint();
        res.color = 0x00FF00;
        res.border = 2;
        res.corners = [5];
        return res;
    }

    public function new() {
        super();
        this.heightPt = 15;
        this.id = get_field1();
        this.skin = get_field3();
        this._onInitialize();
        this._onCreate();
    }
}
