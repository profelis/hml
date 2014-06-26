package ;

class Ab extends test.A implements test.ITools<flash.display.Sprite> {

    var str2_initialized:Bool = false;

    @:isVar public var str2(get, set):String;

    var sprite_initialized:Bool = false;

    @:isVar public var sprite(get, set):flash.display.Sprite;

    var child1_initialized:Bool = false;

    @:isVar public var child1(get, set):flash.text.TextField;

    var child2_initialized:Bool = false;

    @:isVar public var child2(get, set):flash.display.Sprite;

    var child3_initialized:Bool = false;

    @:isVar public var child3(get, set):flash.display.Sprite;

    inline function get_field0():String {
        /* ui/Ab.xml:7 characters: 8-17 */
        var res = 'as';
        return res;
    }

    function set_str2(value:String):String {
        return str2 = value;
    }

    function get_str2():String {
        /* ui/Ab.xml:7 characters: 35-44 */
        if (str2_initialized) return str2;
        str2_initialized = true;
        var res = null;
        this.str2 = res;
        return res;
    }

    function set_sprite(value:flash.display.Sprite):flash.display.Sprite {
        return sprite = value;
    }

    function set_child1(value:flash.text.TextField):flash.text.TextField {
        return child1 = value;
    }

    inline function get_field1():flash.events.MouseEvent -> StdTypes.Void {
        /* ui/Ab.xml:10 characters: 114-119 */
        var res = function (event:flash.events.MouseEvent):StdTypes.Void { trace('click'); };
        return res;
    }

    function get_child1():flash.text.TextField {
        /* ui/Ab.xml:10 characters: 3-17 */
        if (child1_initialized) return child1;
        child1_initialized = true;
        var res = new flash.text.TextField();
        this.child1 = res;
        /* ui/Ab.xml:10 characters: 47-52 */
        res.alpha = 0.78;
        /* ui/Ab.xml:10 characters: 74-83 */
        res.textColor = 0xFF0000;
        /* ui/Ab.xml:10 characters: 60-64 */
        res.text = 'tada';
        /* ui/Ab.xml:10 characters: 95-105 */
        res.selectable = false;
        res.addEventListener(flash.events.MouseEvent.CLICK, get_field1());
        /* ui/Ab.xml:10 characters: 31-32 */
        res.x = 100;
        /* ui/Ab.xml:10 characters: 39-40 */
        res.y = 200;
        return res;
    }

    function set_child2(value:flash.display.Sprite):flash.display.Sprite {
        return child2 = value;
    }

    function get_child2():flash.display.Sprite {
        /* ui/Ab.xml:11 characters: 3-11 */
        if (child2_initialized) return child2;
        child2_initialized = true;
        var res = new flash.display.Sprite();
        this.child2 = res;
        /* ui/Ab.xml:11 characters: 41-42 */
        res.x = 100;
        /* ui/Ab.xml:11 characters: 25-32 */
        res.visible = false;
        return res;
    }

    function set_child3(value:flash.display.Sprite):flash.display.Sprite {
        return child3 = value;
    }

    function get_child3():flash.display.Sprite {
        /* ui/Ab.xml:12 characters: 3-11 */
        if (child3_initialized) return child3;
        child3_initialized = true;
        var res = new flash.display.Sprite();
        this.child3 = res;
        /* ui/Ab.xml:12 characters: 41-42 */
        res.x = 100;
        /* ui/Ab.xml:12 characters: 25-32 */
        res.visible = false;
        return res;
    }

    function get_sprite():flash.display.Sprite {
        /* ui/Ab.xml:9 characters: 2-10 */
        if (sprite_initialized) return sprite;
        sprite_initialized = true;
        var res = new flash.display.Sprite();
        this.sprite = res;
        res.addChild(child1);
        res.addChild(child2);
        res.addChild(child3);
        return res;
    }

    public function new() {
        /* ui/Ab.xml:1 characters: 1-2 */
        super();
        /* ui/Ab.xml:4 characters: 2-6 */
        this.name = 'testName';
        /* ui/Ab.xml:7 characters: 2-6 */
        this.list.push(get_field0());
        this.list.push(str2);
        get_sprite();
    }
}
