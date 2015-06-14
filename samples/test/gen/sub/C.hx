package sub;

class C extends Ab {

    var unbind_this_name:Void -> Void;

    override public function destroyHml():Void {
        super.destroyHml();
        try { unbind_this_name(); } catch (e:Dynamic) {}
    }
    

    public function new() {
        /* ui/sub/C.xml:1 characters: 1-8 */
        super();
        /* ui/sub/C.xml:1 characters: 24-28 */
        unbind_this_name = bindx.BindExt.exprTo('cName2', this.name);
    }
}
