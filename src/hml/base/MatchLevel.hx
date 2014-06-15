package hml.base;

/**
 * Match Levels
 * None : 0
 * Global : 100
 * Package : 200
 * Module : 300
 * Class : 400
 */
enum MatchLevel {
	None;
	GlobalLevel;
	PackageLevel;
	ModuleLevel;
	ClassLevel;
	CustomLevel(main:MatchLevel, offset:UInt);
}

class MathLevelUtils {
	static public function getLevelNum(matchLevel:MatchLevel):UInt {
		return switch (matchLevel) {
			case None: 0;
			case GlobalLevel: 100;
			case PackageLevel: 200;
			case ModuleLevel: 300;
			case ClassLevel: 400;
			case CustomLevel(main, offset): getLevelNum(main) + offset;
		}
	}

	static public function findMatch<T>(items:Iterable<T>, getLevel:T->MatchLevel):T {
		var level:UInt = 0;
		var res:T = null;
		for (i in items) {
			var l = getLevelNum(getLevel(i));
			#if hml_debug
			if (l > 0 && l == level) {
				haxe.macro.Context.error("Items with same match level: " + i + " : " + res, haxe.macro.Context.currentPos());
			}
			#end
			if (l > level) {
				res = i;
				level = l;
			}
		}
		return res;
	}
}