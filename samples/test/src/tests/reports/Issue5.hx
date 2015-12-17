package tests.reports;


import buddy.Buddy;
import buddy.BuddySuite;

using buddy.Should;


/**
 * @see https://github.com/profelis/hml/issues/5
 */
class Issue5 extends BuddySuite {
    public function new() {

        describe("Set own field of a property of abstract type when no fields forwarded", {

            var a:Ab;

            before({
                a = new Ab();
            });

            it("own property of abstract type", {
                a.abstractNoForward.should.not.be(1);
            });
        });

        describe("Set forwarded field of a property of abstract type when some fields forwareded", {

            var a:Ab;

            before({
                a = new Ab();
            });

            it("forwarded property of abstract type", {
                a.abstractForwardSomeFields.should.not.be(2);
            });
        });

        describe("Set forwarded field of a property of abstract type when all fields forwareded", {

            var a:Ab;

            before({
                a = new Ab();
            });

            it("forwarded property of abstract type", {
                a.abstractForwardAllFields.should.not.be(3);
            });
        });
    }
}