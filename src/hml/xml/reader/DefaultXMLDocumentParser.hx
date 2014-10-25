package hml.xml.reader;

import com.tenderowls.xml176.Xml176Parser.Xml176Document;
import hml.base.MatchLevel;
import hml.xml.Data;

using hml.base.MatchLevel;

class DefaultXMLDocumentParser extends DefaultXMLElementParser {
    override public function match(xml:Xml176Document, parent:XMLData):MatchLevel {
        return switch (xml.document.nodeType) {
            case Xml.Document: PackageLevel;
            default: None;
        };
    }

    override public function parse(node:Xml176Document, parent:XMLData, parser:IXMLParser<XMLData>):XMLData {
        var res = new XMLDataRoot();
        res.root = res;
        parseData(res, node.sub(node.document.firstElement()), res, parser);
        res.parent = null;
        return res;
    }
}