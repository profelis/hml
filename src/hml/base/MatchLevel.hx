package hml.base;

/**
 * Match Levels
 * 
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
	/**
	 * Convert MatchLevel to UInt value
	 * 
	 * @param  matchLevel
	 * @return       	  UInt equivalent of MatchLevel value
	 */
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

	/**
	 * Find optimal item
	 *
	 * @param items    set of items
	 * @param getLevel callback which return item's mathLevel
	 * @return         optimal item
	 */
	static public function findMatch<T>(items:Iterable<T>, getLevel:T->MatchLevel):T {
		var level:UInt = 0;
		var res:T = null;
		for (i in items) {
			var l = getLevelNum(getLevel(i));
			if (l > 0 && l == level) {
				throw "Items with same match level: " + Type.getClassName(Type.getClass(i)) + " : " + Type.getClassName(Type.getClass(res));
			}
			if (l > level) {
				res = i;
				level = l;
			}
		}
		return res;
	}
}