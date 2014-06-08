package ;

class Ba extends test.B {

    var test2_initialized:Bool = false;

    @:isVar public var test2(get, set):test.A;

    function set_test2(value:test.A):test.A {
        return test2 = value;
    }

    @:expose inline function get_field0():String {
        var res = 'foo';
        return res;
    }

    function get_test2():test.A {
        if (test2_initialized) return test2;
        test2_initialized = true;
        var res = new test.A();
        this.test2 = res;
        res.name = get_field0();
        return res;
    }

    public function new() {
        super();
        get_test2();
    }
}