package ;

import flash.display.Sprite;
using StringTools;

@:rtti
class Ba extends data.B implements data.IEmptyInterface<haxe.Timer> {

    var test2_initialized:Bool = false;

    @:isVar public var test2(get, set):Ab;

    public function destroyHml():Void {
        
    }
    

    function set_test2(value:Ab):Ab {
        test2_initialized = true;
        return test2 = value;
    }

    function get_test2():Ab {
        /* ui/Ba.xml:8 characters: 9-14 */
        if (test2_initialized) return test2;
        test2_initialized = true;
        this.test2 = new Ab();
        var res = this.test2;
        /* ui/Ba.xml:9 characters: 13-20 */
        res.name = 'foo';
        return res;
    }

    public function new() {
        /* ui/Ba.xml:1 characters: 1-2 */
        super();
        /* ui/Ba.xml:31 characters: 5-14 */
        this.stringMap = ["1"=>'${this.test2.name}'];
        /* ui/Ba.xml:32 characters: 5-11 */
        this.intMap = [for (i in 1...10) i=>'$i'];
        /* ui/Ba.xml:33 characters: 5-14 */
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
