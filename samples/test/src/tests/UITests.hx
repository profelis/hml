package tests;

import buddy.Buddy;
import buddy.BuddySuite;
import data.A;
import data.B;
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
using utest.Assert;

class UITests extends BuddySuite {
    public function new() {

        describe("base hml test", function () {
            
            var a:Ab;
            var b:Ba;
            
            beforeEach(function () {
                a = new Ab();
                b = Type.createInstance(Ba, []);
            });
            
            it("hml should extend base classes", function () {
                Std.is(a, A).should.be(true);
                Std.is(b, B).should.be(true);
            });
            
            it("hml should support parse attributes", function () {
                a.name.should.be("testName");
                a.alpha.should.be(0.5);
            });
            
            it("hml should support maps", function () {
                b.stringMap.same(["1" => b.test2.name]);
                b.intMap.same([for (i in 1...10) i => '$i']);
                
                var objMap = b.objectMap;
                for (k in objMap.keys()) {
                    Std.is(k, Date).should.be(true);
                    objMap.get(k).should.be("today");
                }
            });
            
            it("hml should support childrens", function () {
                a.numChildren.should.be(1);
                a.sprite.numChildren.should.be(3);
                Std.is(a.sprite.getChildAt(0), TextField).should.be(true);
                Std.is(a.sprite.getChildAt(1), Sprite).should.be(true);

                a.asset.x.should.be(50);
                a.asset.y.should.be(50.0);
                a.asset.visible.should.be(true);
            });
            
            it("hml should fill arrays", function () {
                a.list.should.containExactly(["as", null]);
            });

            it("hml should call subfields", function () {
                a.publicB.sprite.x.should.be(100);
                b.test2.child1.text.should.be("FooBar");
            });
        });
        
        describe("hml magic meta", function () {
            
            var a:Ab;
            var b:Ba;
            
            beforeEach(function () {
                a = Type.createInstance(Ab, []);
                b = Type.createInstance(Ba, []);
            });
            
            it("hml should generate class meta", function () {
                var typeMeta = Meta.getType(Ab);
                var m:Array<String> = typeMeta.field("MagicMeta");
                m.should.containExactly(["foo", "bar"]);
            });
            
            it("hml should generate fields meta", function () {
                var fieldsMeta = Meta.getFields(Ab);
                fieldsMeta.should.not.be(null);
                
                var spriteMeta:Dynamic<String> = fieldsMeta.field("sprite");
                spriteMeta.same( { FooMeta: [12] } ); // @FooMeta(12)
                
                var stringMeta:Dynamic<String> = fieldsMeta.field("string");
                stringMeta.same( { StringMeta: null } ); // @StringMeta
            });
            
            it("hml should generate @: meta", function () {
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
        
        describe("hml magic namespace", function () {
            
            var a:Ab;
            var b:Ba;
            
            beforeEach(function () {
                a = new Ab();
                b = Type.createInstance(Ba, []);
            });
            
            it("hml should support Implements", function () {
                Std.is(a, ITools).should.be(true);
                Std.is(b, IEmptyInterface).should.be(true);
            });
            
            it("hml should support Implements, rtti check", function () {
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
                        i.params[0].match(CClass("haxe.Timer", _)).should.be(true);
                    case _:
                }
            });
        });
        
        describe("hml magic declarations", function () {
            
            var a:Ab;
            var b:Ba;
            
            beforeEach({
                a = new Ab();
                b = new Ba();
            });
            
            it("hml should generate public declarations", function () {
                a.string.should.be(a.user.name);
                a.string2.should.be("ab");

                b.test2.should.not.be(null);
                b.test2.name.should.be("foo");
                
                a.publicB.should.not.be(null);
                a.publicB.test2.should.be(null);
            });
            
            it("hml should generate public declarations", function () {
                // child1.text == privateString;
                a.child1.text.should.be("text in private string");
            });
        });
        
        describe("hml magic script", function () {
            
            var b:Ba;
            
            beforeEach(function () {
                b = new Ba();
            });
            
            it("hml should inject scripts", function () {
                b.t.should.be(true);
                b.n().should.be(32);
            });
        });
        
        describe("hml should support bindx2", function () {
        
            var a:Ab;
            
            beforeEach(function () {
                a=  new Ab();
            });
            
            it("bind and unbind expr", function () {
                a.child2.x.should.be(100);
                a.child3.x.should.be(200);
                
                a.user.name.should.not.be(null);
                a.child2.name.should.be(a.user.name);
                a.string.should.be(a.user.name);
                
                a.user.name = "user2";
                
                a.child2.name.should.be(a.user.name);
                a.string.should.be(a.user.name);
                
                a.destroyHml();
                
                a.user.name = "user3";
                
                a.child2.name.should.not.be(a.user.name);
                a.string.should.not.be(a.user.name);
            });
        });
    }
}