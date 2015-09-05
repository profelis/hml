package hml.base;

class StringUtils {
    public static function splitLines(str:String):Array<String> {
        return ~/\n\r|\r\n|\r|\n/g.split(str);
    }
}
