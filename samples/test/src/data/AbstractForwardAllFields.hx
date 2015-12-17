package data;


@:forward
abstract AbstractForwardAllFields(B)
{
    public function new () : Void {
        this = new B();
    }
}