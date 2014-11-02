package tests;

import buddy.Buddy;
import buddy.BuddySuite;
import data.IEmptyInterface;
import data.ITools;
import flash.text.TextField;
import flash.display.Sprite;
import flash.xml.XMLParser;
import haxe.rtti.*;
import haxe.rtti.CType;

using buddy.Should;
using haxe.rtti.Meta;
using Lambda;

class UITests extends BuddySuite implements Buddy  {
    public function new() {

        describe("base hml test", {
            
            var a:Ab;
            var b:Ba;
            
            before({
                a = new Ab();
                b = Type.createInstance(Ba, []);
            });
            
            it("hml should support parse attributes", {
                a.name.should.be("testName");
                a.alpha.should.be(0.5);
            });
            
            it("hml should support childrens", {
                a.numChildren.should.be(1);
                
                a.sprite.numChildren.should.be(3);
                var tf:TextField = cast(a.sprite.getChildAt(0), TextField);
                tf.should.not.be(null);
                
                var ch2 = cast(a.sprite.getChildAt(1), Sprite);
                ch2.should.not.be(null);
            });
            
            it("hml should fill arrays", {
                a.list.length.should.be(2);
                a.list[0].should.be("as");
                a.list[1].should.be(null);
                a.list.should.containExactly(["as", null]);
            });
            
            after({
                a = null;
                b = null;
            });
        });
        
        describe("hml magic namespace", {
            
            var a:Ab;
            var b:Ba;
            
            before({
                a = new Ab();
                b = Type.createInstance(Ba, []);
            });
            
            it("hml should support Implements", {
                Std.is(a, ITools).should.be(true);
                Std.is(b, IEmptyInterface).should.be(true);
            });
            
            it("hml should support Implements, rtti check", {
                var artti = untyped Ab.__rtti;
                var ainfo = new XmlParser().processElement(Xml.parse(artti).firstElement());
                ainfo.match(TClassdecl(_)).should.be(true);
                switch (ainfo) {
                    case TClassdecl(c):
                        var spriteField = c.fields.find(function (it) return it.name == "sprite");
                        spriteField.should.not.be(null);
                        spriteField.type.match(CClass("flash.display.Sprite", _)).should.be(true);
                    case _:
                }
                Std.is(b, IEmptyInterface).should.be(true);
                
                var brtti = untyped Ba.__rtti;
                var binfo = new XmlParser().processElement(Xml.parse(brtti).firstElement());
                binfo.match(TClassdecl(_)).should.be(true);
                switch (binfo) {
                    case TClassdecl(c):
                        c.interfaces.length.should.be(1);
                        var i = c.interfaces.pop();
                        i.path.should.be("data.IEmptyInterface");
                        i.params.length.should.be(1);
                        i.params.first().match(CClass("haxe.Timer", _)).should.be(true);
                    case _:
                }
            });
            
            after({
                a = null;
                b = null;
            });
        });
        
        describe("hml magic declarations", {
            
            var a:Ab;
            var b:Ba;
            
            before({
                a = new Ab();
                b = Type.createInstance(Ba, []);
            });
            
            it("hml should generate public declarations", {
                a.string.should.be("23");
                
                a.string2.should.be("ab");
                
                // child1.text == privateString;
                a.child1.text.should.be("text in private string");
                
                b.test2.should.not.be(null);
                b.test2.name.should.be("foo");
            });
            
        });
    }
}