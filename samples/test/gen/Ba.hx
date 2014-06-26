package ;

class Ba extends test.B {

    var test2_initialized:Bool = false;

    @:isVar public var test2(get, set):Ab;

    function set_test2(value:Ab):Ab {
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
        get_test2();
    }
}
