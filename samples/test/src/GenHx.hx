package ;

/**
 * ...
 * @author deep <system.grand@gmail.com>
 */

class GenHx {
	
	static function main() initHML();

	static macro function initHML() {
		hml.Hml.registerProcessor(new hml.xml.XMLProcessor([new hml.xml.XMLProcessor.SpriteXMLAdapter(), new hml.xml.XMLProcessor.DefaultXMLAdapter()]));
		return macro hml.Hml.parse({path:"gen", autoCreate:true}, "ui");
	}
	
}