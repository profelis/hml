package;

import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;
import ru.stablex.ui.UIBuilder;


/**
* Simple demo project for StablexUI
*/
class Main extends ru.stablex.ui.widgets.Widget {
    /**
    * Enrty point
    *
    */
    static public function main () : Void{
        Lib.current.stage.align     = StageAlign.TOP_LEFT;
        Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;

        // with hml you dowsn't need register something

        //register Main so we can use it in xml. Full classpath should be specified here
        // UIBuilder.regClass("Main");
        //If we want to use com.example.SomeClass in xml we need to do this:

        //initialize StablexUI
        UIBuilder.init();

        //register skins. You can also define skins separately for each widget right in ui xml
        UIBuilder.regSkins('assets/skins.xml');

        //Create our UI
        Lib.current.addChild( new ui.Index() );
    }//function main()


}//class Main


