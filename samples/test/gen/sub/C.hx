package sub;

class C extends Ab {

    @:expose inline function get_field0():String {
        var res = 'cName2';
        return res;
    }

    public function new() {
        super();
        this.name = get_field0();
    }
}