package ;

class Ba extends test.B {

    var test2_initialized:Bool = false;

    @:isVar public var test2(get, set):Ab;

    function set_test2(value:Ab):Ab {
        return test2 = value;
    }

    @:extern inline function get_field0():String {
        var res = 'foo';
        return res;
    }

    function get_test2():Ab {
        if (test2_initialized) return test2;
        test2_initialized = true;
        var res = new Ab();
        this.test2 = res;
        res.name = get_field0();
        return res;
    }

    public function new() {
        super();
        get_test2();
    }
}
