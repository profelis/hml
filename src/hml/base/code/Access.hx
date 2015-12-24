package hml.base.code;


/**
 * Field access modifiers
 */
@:enum abstract Access (String) to String
{
    var APublic   = 'public';
    var APrivate  = 'private';
    var AStatic   = 'static';
    var AOverride = 'override';
    var ADynamic  = 'dynamic';
    var AInline   = 'inline';
    var AMacro    = 'macro';

    static private var convention = [AMacro, AStatic, AOverride, APublic, APrivate, AInline, ADynamic];

    /**
     * Change access modifiers order to follow field declaration convention.
     * Modifies `access` array in place.
     */
    static public function sort (access:Array<Access>) : Void
    {
        var hasCount = 0;
        for (current in convention) {
            if (access.remove(current)) {
                access.insert(hasCount, current);
                hasCount ++;
            }
        }
    }

}//abstract Access