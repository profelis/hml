package hml.xml.reader;

import hml.base.MatchLevel;
import com.tenderowls.xml176.Xml176Parser;

interface IXMLParser<B> {
    public function parse(xml:Xml176Document, parent:B):Null<B>;
}

interface IXMLNodeParser<B> {
    public function match(xml:Xml176Document, parent:B):MatchLevel;
    public function parse(xml:Xml176Document, parent:B, parser:IXMLParser<B>):B;
}