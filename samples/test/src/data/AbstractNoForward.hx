package data;


abstract AbstractNoForward(B)
{
    public var abstractField (get,set) : Int;


    public function new () : Void {
        this = new B();
    }


    function get_abstractField () return this.b;
    function set_abstractField (v) return this.b = v;
}