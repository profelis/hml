package ;

import flash.display.Sprite;
using StringTools;

class Ba extends data.B {

    var test2_initialized:Bool = false;

    @:isVar public var test2(get, set):Ab;

    function set_test2(value:Ab):Ab {
        test2_initialized = true;
        return test2 = value;
    }

    function get_test2():Ab {
        /* ui/Ba.xml:2 characters: 2-7 */
        if (test2_initialized) return test2;
        test2_initialized = true;
        var res = new Ab();
        this.test2 = res;
        /* ui/Ba.xml:3 characters: 3-10 */
        res.name = 'foo';
        return res;
    }

    public function new() {
        /* ui/Ba.xml:1 characters: 1-2 */
        super();
        /* ui/Ba.xml:25 characters: 5-14 */
        this.stringMap = ["1"=>'${this.test2.name}'];
        /* ui/Ba.xml:26 characters: 5-11 */
        this.intMap = [for (i in 1...10) i=>'$i'];
        /* ui/Ba.xml:27 characters: 5-14 */
        this.objectMap = [Date.now() => "today"];
        get_test2();
    }

    // comment



        // comment 2
        var t = true;
        function n() {
            trace(t);
            trace("a".trim());
        }

        /**
           comment 3
        **/
}
