package hml.xml.adapters.base;

import hml.xml.writer.IHaxeWriter.IHaxeNodeWriter;
import haxe.macro.Expr;
import hml.xml.typeResolver.IHaxeTypeResolver;
import hml.xml.reader.IXMLParser;

class MergedAdapter<B, N, T> implements IAdapter<B, N, T> {
	public var adapters:Array<IAdapter<B, N, T>>;

	public function new(adapters:Array<IAdapter<B, N, T>>) {
		this.adapters = adapters;
	}

	public function getXmlNodeParsers():Array<IXMLNodeParser<B>> {
		return foreach(getXmlNodeParsers);
	}

	public function getXmlDataNodeParsers():Array<IXMLDataNodeParser<B, N, N>> {
		return foreach(getXmlDataNodeParsers);
	}

	public function getTypeResolvers():Array<IHaxeTypeResolver<N, T>> {
		return foreach(getTypeResolvers);
	}

	public function getNodeWriters():Array<IHaxeNodeWriter<N>> {
		return foreach(getNodeWriters);
	}

	macro static function foreach(methodExpr:Expr) {
		var method = switch (methodExpr.expr) {
			case EField(_, field): field;
			case EConst(CIdent(id)): id;
			case _: throw "assert";
		}
		return macro {
			var res = [];
			for (a in adapters) {
				var t = a.$method();
				if (t != null) res = res.concat(t);
			}
			res;
		}
	}
}