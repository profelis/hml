package tests.reports;

import buddy.Buddy;
import buddy.BuddySuite;

using buddy.Should;

class PR1 extends BuddySuite {
    public function new() {
        
        describe("Equate if a node is a property even if the value is a DisplayObject", {
            
            var a:Ab;
                
            before({
                a = new Ab();     
            });
            
            it("property is DisplayObject", {
                a.asset.should.not.be(true);
            });
        });
    }
}