package ;

/**
 * ...
 * @author deep <system.grand@gmail.com>
 */

class GenHx {
	static function main() initHML();

	static macro function initHML() {
		hml.xml.adapters.StablexUIAdapter.register();

		return macro hml.Hml.parse({path:"gen"}, "ui");
	}
}