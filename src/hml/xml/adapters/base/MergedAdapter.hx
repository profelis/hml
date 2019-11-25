package hml.xml.adapters.base;

import hml.xml.writer.IHaxeWriter.IHaxeNodeWriter;
import haxe.macro.Expr;
import hml.xml.typeResolver.IHaxeTypeResolver;
import hml.xml.reader.IXMLParser;

class MergedAdapter<B, N, T> implements IAdapter<B, N, T> {
	var adapters:Array<IAdapter<B, N, T>>;

	public function new(adapters:Array<IAdapter<B, N, T>>) {
		this.adapters = adapters;
	}

	public function getXmlNodeParsers():Array<IXMLNodeParser<B>> {
		var res = [];
		for (a in adapters) {
			var t = a.getXmlNodeParsers();
			if (t != null) res = res.concat(t);
		}
		return res;
	}

	public function getXmlDataNodeParsers():Array<IXMLDataNodeParser<B, N, N>> {
		var res = [];
		for (a in adapters) {
			var t = a.getXmlDataNodeParsers();
			if (t != null) res = res.concat(t);
		}
		return res;
	}

	public function getTypeResolvers():Array<IHaxeTypeResolver<N, T>> {
		var res = [];
		for (a in adapters) {
			var t = a.getTypeResolvers();
			if (t != null) res = res.concat(t);
		}
		return res;
	}

	public function getNodeWriters():Array<IHaxeNodeWriter<N>> {
		var res = [];
		for (a in adapters) {
			var t = a.getNodeWriters();
			if (t != null) res = res.concat(t);
		}
		return res;
	}

}