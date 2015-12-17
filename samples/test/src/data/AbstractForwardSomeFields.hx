package data;


@:forward(b)
abstract AbstractForwardSomeFields(B)
{
    public function new () : Void {
        this = new B();
    }
}