package ;

@MagicMeta('foo', "bar")
        @:rtti
class Ab extends data.A implements data.ITools<flash.display.Sprite> {

    var string_initialized:Bool = false;

    @StringMeta
    @:isVar public var string(get, set):String;

    var string2_initialized:Bool = false;

    @:isVar public var string2(get, set):String;

    var publicB_initialized:Bool = false;

    @:isVar public var publicB(get, set):Ba;

    var privateString_initialized:Bool = false;

    @:isVar var privateString(get, set):String;

    var str2_initialized:Bool = false;

    @:isVar public var str2(get, set):String;

    var sprite_initialized:Bool = false;

    @FooMeta(12)
    @:isVar public var sprite(get, set):flash.display.Sprite;

    var child1_initialized:Bool = false;

    @:isVar public var child1(get, set):flash.text.TextField;

    var child2_initialized:Bool = false;

    @:isVar public var child2(get, set):flash.display.Sprite;

    var unbind_child2_x:Void -> Void;

    var child3_initialized:Bool = false;

    @:isVar public var child3(get, set):flash.display.Sprite;

    var unbind_child3_x:Void -> Void;

    public function destroyHml():Void {
        try { unbind_child2_x(); } catch (e:Dynamic) {}
        try { unbind_child3_x(); } catch (e:Dynamic) {}
    }
    

    function set_string(value:String):String {
        string_initialized = true;
        return string = value;
    }

    function get_string():String {
        /* ui/Ab.xml:26 characters: 9-18 */
        if (string_initialized) return string;
        string_initialized = true;
        var res = "23";
        this.string = res;
        return res;
    }

    function set_string2(value:String):String {
        string2_initialized = true;
        return string2 = value;
    }

    function get_string2():String {
        /* ui/Ab.xml:31 characters: 9-18 */
        if (string2_initialized) return string2;
        string2_initialized = true;
        var res = "ab";
        this.string2 = res;
        return res;
    }

    function set_publicB(value:Ba):Ba {
        publicB_initialized = true;
        return publicB = value;
    }

    function get_publicB():Ba {
        /* ui/Ab.xml:32 characters: 9-14 */
        if (publicB_initialized) return publicB;
        publicB_initialized = true;
        var res = new Ba();
        this.publicB = res;
        /* ui/Ab.xml:32 characters: 29-34 */
        res.test2 = null;
        return res;
    }

    function set_privateString(value:String):String {
        privateString_initialized = true;
        return privateString = value;
    }

    function get_privateString():String {
        /* ui/Ab.xml:36 characters: 9-18 */
        if (privateString_initialized) return privateString;
        privateString_initialized = true;
        var res = 'text in private string';
        this.privateString = res;
        return res;
    }

    inline function get_someEvent__0():flash.events.Event -> StdTypes.Void {
        /* ui/Ab.xml:1 characters: 59-68 */
        var res = function (event:flash.events.Event):StdTypes.Void { trace('some event meta magic'); };
        return res;
    }

    inline function get_string__0():String {
        /* ui/Ab.xml:7 characters: 8-17 */
        var res = 'as';
        return res;
    }

    function set_str2(value:String):String {
        str2_initialized = true;
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
        sprite_initialized = true;
        return sprite = value;
    }

    function set_child1(value:flash.text.TextField):flash.text.TextField {
        child1_initialized = true;
        return child1 = value;
    }

    inline function get_click__0():flash.events.MouseEvent -> StdTypes.Void {
        /* ui/Ab.xml:15 characters: 4-9 */
        var res = function (event:flash.events.MouseEvent):StdTypes.Void { trace('click'); this.dispatchEvent(new flash.events.Event('someEvent')); };
        return res;
    }

    function get_child1():flash.text.TextField {
        /* ui/Ab.xml:14 characters: 3-17 */
        if (child1_initialized) return child1;
        child1_initialized = true;
        var res = new flash.text.TextField();
        this.child1 = res;
        /* ui/Ab.xml:14 characters: 47-52 */
        res.alpha = 0.78;
        /* ui/Ab.xml:14 characters: 81-90 */
        res.textColor = 0xFF0000;
        /* ui/Ab.xml:14 characters: 60-64 */
        res.text = privateString;
        /* ui/Ab.xml:14 characters: 102-112 */
        res.selectable = false;
        res.addEventListener(flash.events.MouseEvent.CLICK, get_click__0());
        /* ui/Ab.xml:14 characters: 31-32 */
        res.x = 100;
        /* ui/Ab.xml:14 characters: 39-40 */
        res.y = 200;
        return res;
    }

    function set_child2(value:flash.display.Sprite):flash.display.Sprite {
        child2_initialized = true;
        return child2 = value;
    }

    function get_child2():flash.display.Sprite {
        /* ui/Ab.xml:17 characters: 3-11 */
        if (child2_initialized) return child2;
        child2_initialized = true;
        var res = new flash.display.Sprite();
        this.child2 = res;
        /* ui/Ab.xml:17 characters: 41-42 */
        unbind_child2_x = bindx.BindExt.exprTo(100, res.x);
        /* ui/Ab.xml:17 characters: 25-32 */
        res.visible = false;
        return res;
    }

    function set_child3(value:flash.display.Sprite):flash.display.Sprite {
        child3_initialized = true;
        return child3 = value;
    }

    function get_child3():flash.display.Sprite {
        /* ui/Ab.xml:19 characters: 3-11 */
        if (child3_initialized) return child3;
        child3_initialized = true;
        var res = new flash.display.Sprite();
        this.child3 = res;
        /* ui/Ab.xml:19 characters: 41-42 */
        unbind_child3_x = bindx.BindExt.exprTo(200, res.x);
        /* ui/Ab.xml:19 characters: 25-32 */
        res.visible = false;
        return res;
    }

    function get_sprite():flash.display.Sprite {
        /* ui/Ab.xml:13 characters: 2-10 */
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
        /* ui/Ab.xml:1 characters: 103-108 */
        this.alpha = 0.5;
        this.addEventListener("someEvent", get_someEvent__0());
        /* ui/Ab.xml:4 characters: 2-6 */
        this.name = 'testName';
        /* ui/Ab.xml:7 characters: 2-6 */
        this.list.push(get_string__0());
        this.list.push(str2);
        this.addChild(sprite);
    }
}
