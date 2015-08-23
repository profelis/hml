package hml.properties;

import hml.base.Strings;

class PropertiesData {

    public var file:String;
    public var type:String;

    public function new() {
        nodes = [];
    }

    public var nodes:Array<PropertiesNodeData>;

    public function toString():String {
        var res = new Strings();
        res += 'Data: file $file type ${type}\n';
        for (n in nodes) {
            res += n.toString();
            res += "\n";
        }
        return res;
    }
}

class PropertiesNodeData {
    public function new() {}

    public var key:String;
    public var value:String;

    public function toString():String return '$key = $value';
}

class PropertiesType {

    public var type:{pack:String, name:String};

    public function new() {
        nodes = [];
    }

    public var model:PropertiesData;

    public var nodes:Array<PropertiesNodeType>;

    public function getNodeById(id:String):PropertiesNodeType {
        for (n in nodes) if (n.id == id) return n;
        return null;
    }
}

class PropertiesNodeType {
    public var id:String;

    public var rawValue:String;

    public function new() {}

    public function toString():String return '$id = $rawValue';
}
