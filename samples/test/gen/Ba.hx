package ;

import flash.display.Sprite;
using StringTools;

@:rtti
class Ba extends data.B implements data.IEmptyInterface<haxe.Timer> {

    var test2_initialized:Bool = false;

    @:isVar public var test2(get, set):Ab;

    var sprite_initialized:Bool = false;

    @:isVar public var sprite(get, set):flash.display.Sprite;

    public function destroyHml():Void {
        
    }
    

    function set_test2(value:Ab):Ab {
        test2_initialized = true;
        return test2 = value;
    }

    function get_test2():Ab {
        /* ui/Ba.xml:9 characters: 9-14 */
        if (test2_initialized) return test2;
        test2_initialized = true;
        this.test2 = new Ab();
        var res = this.test2;
        /* ui/Ba.xml:10 characters: 13-20 */
        res.name = 'foo';
        /* ui/Ba.xml:9 characters: 27-38 */
        res.child1.text = 'FooBar';
        return res;
    }

    function set_sprite(value:flash.display.Sprite):flash.display.Sprite {
        sprite_initialized = true;
        return sprite = value;
    }

    function get_sprite():flash.display.Sprite {
        /* ui/Ba.xml:13 characters: 9-17 */
        if (sprite_initialized) return sprite;
        sprite_initialized = true;
        this.sprite = new flash.display.Sprite();
        var res = this.sprite;
        return res;
    }

    public function new() {
        /* ui/Ba.xml:1 characters: 1-2 */
        super();
        /* ui/Ba.xml:34 characters: 5-14 */
        this.stringMap = ["1"=>'${this.test2.name}'];
        /* ui/Ba.xml:35 characters: 5-11 */
        this.intMap = [for (i in 1...10) i=>'$i'];
        /* ui/Ba.xml:36 characters: 5-14 */
        this.objectMap = [Date.now() => "today"];
    }

    // comment



        // comment 2
        public var t = true;
        public function n() {
            return Std.parseInt(" 32 ".trim());
        }

        /**
           comment 3
        **/
}
