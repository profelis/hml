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
using Reflect;

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
            
            it("hml should support maps", {
                [for (k in b.stringMap.keys()) k].should.containExactly(["1"]);
                b.stringMap.get("1").should.be(b.test2.name);
                
                var intMap = [for (i in 1...10) i => '$i'];
                for (k in b.intMap.keys()) {
                    b.intMap.get(k).should.be(intMap.get(k));
                }
                
                for (k in b.objectMap.keys()) {
                    Std.is(k, Date).should.be(true);
                    b.objectMap.get(k).should.be("today");
                }
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
                a.list.should.containExactly(["as", null]);
            });
        });
        
        describe("hml magic meta", {
            
            var a:Ab;
            var b:Ba;
            
            before( {
                a = Type.createInstance(Ab, []);
                b = Type.createInstance(Ba, []);
            });
            
            it("hml should generate class meta", {
                var typeMeta = Meta.getType(Ab);
                var m:Array<String> = typeMeta.field("MagicMeta");
                m.should.not.be(null);
                m.should.containExactly(["foo", "bar"]);
            });
            
            it("hml should generate fields meta", {
                var fieldsMeta = Meta.getFields(Ab);
                // @FooMeta(12)
                var spriteMeta:Dynamic<String> = fieldsMeta.field("sprite");
                spriteMeta.fields().should.containExactly(["FooMeta"]);
                (spriteMeta.field("FooMeta") == "12").should.be(true);
                // @StringMeta
                var stringMeta:Dynamic<String> = fieldsMeta.field("string");
                stringMeta.fields().should.containExactly(["StringMeta"]);
                (stringMeta.field("StringMeta") == null).should.be(true);
            });
            
            it("hml should generate @: meta", {
                var artti:String = untyped Ab.__rtti;
                var brtti:String = untyped Ba.__rtti;
                artti.should.not.be(null);
                brtti.should.not.be(null);
                try {
                    Xml.parse(artti);
                    Xml.parse(brtti);
                }
                catch (e:Dynamic) {
                    fail("rtti data isn't valid xml");
                }
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
        });
        
        describe("hml magic declarations", {
            
            var a:Ab;
            var b:Ba;
            
            before({
                a = new Ab();
                b = new Ba();
            });
            
            it("hml should generate public declarations", {
                a.string.should.be("23");
                a.string2.should.be("ab");

                b.test2.should.not.be(null);
                b.test2.name.should.be("foo");
                
                a.publicB.should.not.be(null);
                a.publicB.test2.should.be(null);
            });
            
            it("hml should generate public declarations", {
                // child1.text == privateString;
                a.child1.text.should.be("text in private string");
            });
        });
        
        describe("hml magic script", {
            
            var b:Ba;
            
            before({
                b = new Ba();
            });
            
            it("hml should inject scripts", {
                b.t.should.be(true);
                b.n().should.be(32);
            });
        });
    }
}