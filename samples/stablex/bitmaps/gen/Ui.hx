package ;

class Ui extends ru.stablex.ui.widgets.VBox {

    inline function get_field0():ru.stablex.ui.skins.Paint {
        /* ui/Ui.xml:8 characters: 13-23 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/Ui.xml:8 characters: 25-30 */
        res.color = 0x555555;
        return res;
    }

    inline function get_field1():ru.stablex.ui.widgets.Bmp {
        /* ui/Ui.xml:12 characters: 9-12 */
        var res = new ru.stablex.ui.widgets.Bmp();
        /* ui/Ui.xml:12 characters: 14-17 */
        res.src = 'assets/haxe.png';
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field2():ru.stablex.ui.widgets.Bmp {
        /* ui/Ui.xml:15 characters: 9-12 */
        var res = new ru.stablex.ui.widgets.Bmp();
        /* ui/Ui.xml:15 characters: 14-17 */
        res.src = 'assets/haxe.png';
        /* ui/Ui.xml:15 characters: 71-72 */
        res.h = 76;
        /* ui/Ui.xml:15 characters: 38-45 */
        res.xOffset = 72;
        /* ui/Ui.xml:15 characters: 51-58 */
        res.yOffset = 72;
        /* ui/Ui.xml:15 characters: 64-65 */
        res.w = 76;
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field3():ru.stablex.ui.widgets.Bmp {
        /* ui/Ui.xml:18 characters: 9-12 */
        var res = new ru.stablex.ui.widgets.Bmp();
        /* ui/Ui.xml:18 characters: 62-71 */
        res.autoWidth = true;
        /* ui/Ui.xml:18 characters: 14-17 */
        res.src = 'assets/haxe.png';
        /* ui/Ui.xml:18 characters: 79-80 */
        res.h = 148;
        /* ui/Ui.xml:18 characters: 38-45 */
        res.xOffset = 0;
        /* ui/Ui.xml:18 characters: 50-57 */
        res.yOffset = 0;
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field4():ru.stablex.ui.widgets.HBox {
        /* ui/Ui.xml:6 characters: 5-9 */
        var res = new ru.stablex.ui.widgets.HBox();
        /* ui/Ui.xml:6 characters: 24-36 */
        res.childPadding = 30;
        /* ui/Ui.xml:6 characters: 11-18 */
        res.padding = 50;
        /* ui/Ui.xml:6 characters: 42-43 */
        res.widthPt = 100;
        /* ui/Ui.xml:7 characters: 9-13 */
        res.skin = get_field0();
        res._onInitialize();
        res.addChild(get_field1());
        res.addChild(get_field2());
        res.addChild(get_field3());
        res._onCreate();
        return res;
    }

    inline function get_field5():ru.stablex.ui.skins.Paint {
        /* ui/Ui.xml:24 characters: 13-23 */
        var res = new ru.stablex.ui.skins.Paint();
        /* ui/Ui.xml:24 characters: 25-30 */
        res.color = 0x555555;
        return res;
    }

    inline function get_field6():ru.stablex.ui.widgets.Bmp {
        /* ui/Ui.xml:27 characters: 9-12 */
        var res = new ru.stablex.ui.widgets.Bmp();
        /* ui/Ui.xml:27 characters: 14-17 */
        res.src = 'assets/haxe.png';
        /* ui/Ui.xml:27 characters: 46-47 */
        res.h = 100;
        /* ui/Ui.xml:27 characters: 38-39 */
        res.w = 100;
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field7():ru.stablex.ui.widgets.Bmp {
        /* ui/Ui.xml:29 characters: 9-12 */
        var res = new ru.stablex.ui.widgets.Bmp();
        /* ui/Ui.xml:29 characters: 14-17 */
        res.src = 'assets/haxe.png';
        /* ui/Ui.xml:29 characters: 46-47 */
        res.h = 100;
        /* ui/Ui.xml:29 characters: 38-39 */
        res.w = 100;
        res._onInitialize();
        res._onCreate();
        return res;
    }

    inline function get_field8():ru.stablex.ui.widgets.HBox {
        /* ui/Ui.xml:22 characters: 5-9 */
        var res = new ru.stablex.ui.widgets.HBox();
        /* ui/Ui.xml:22 characters: 24-36 */
        res.childPadding = 30;
        /* ui/Ui.xml:22 characters: 11-18 */
        res.padding = 50;
        /* ui/Ui.xml:22 characters: 42-43 */
        res.widthPt = 100;
        /* ui/Ui.xml:23 characters: 9-13 */
        res.skin = get_field5();
        res._onInitialize();
        res.addChild(get_field6());
        res.addChild(get_field7());
        res._onCreate();
        return res;
    }

    public function new() {
        /* ui/Ui.xml:3 characters: 1-5 */
        super();
        /* ui/Ui.xml:3 characters: 109-110 */
        this.h = flash.Lib.current.stage.stageHeight;
        /* ui/Ui.xml:3 characters: 70-71 */
        this.w = flash.Lib.current.stage.stageWidth;
        this._onInitialize();
        this.addChild(get_field4());
        this.addChild(get_field8());
        this._onCreate();
    }
}
