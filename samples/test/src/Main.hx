package ;

class Main{
	static function main() {
		var a = new Ab();
		trace(a.name);
		trace(a.list);
		trace(a.sprite.getChildAt(0).alpha);
		trace(a.sprite.numChildren);
		var c = new sub.C();
		trace(c.name);

		var tools:test.ITools<flash.display.Sprite> = a;
		trace(tools.sprite);

		flash.Lib.current.addChild(a.sprite);
	}
}