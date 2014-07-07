/*
 * Copyright (C)2005-2012 Haxe Foundation
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the "Software"),
 * to deal in the Software without restriction, including without limitation
 * the rights to use, copy, modify, merge, publish, distribute, sublicense,
 * and/or sell copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 */
package com.tenderowls.xml176;

using StringTools;

/* poor'man enum : reduce code size + a bit faster since inlined */
extern private class S {
	public static inline var IGNORE_SPACES 	= 0;
	public static inline var BEGIN			= 1;
	public static inline var BEGIN_NODE		= 2;
	public static inline var TAG_NAME		= 3;
	public static inline var BODY			= 4;
	public static inline var ATTRIB_NAME	= 5;
	public static inline var EQUALS			= 6;
	public static inline var ATTVAL_BEGIN	= 7;
	public static inline var ATTRIB_VAL		= 8;
	public static inline var CHILDS			= 9;
	public static inline var CLOSE			= 10;
	public static inline var WAIT_END		= 11;
	public static inline var WAIT_END_RET	= 12;
	public static inline var PCDATA			= 13;
	public static inline var HEADER			= 14;
	public static inline var COMMENT		= 15;
	public static inline var DOCTYPE		= 16;
	public static inline var CDATA			= 17;
	public static inline var ESCAPE			= 18;
}

class Xml176Document {

    public var document(default,null):Xml;

    public var rawData(default, null):String;
    public var path(default, null):String;

    var ePosInfos:Map<Xml, Pos>;
    var aPosInfos:Map<Xml, Map<String, Pos>>;

    public function new(doc:Xml, rawData, ePosInfos, aPosInfos, path) {
        this.document = doc;
        this.rawData = rawData;
        this.ePosInfos = ePosInfos;
        this.aPosInfos = aPosInfos;
        this.path = path;
    }

    public function getNodePosition(node:Xml):Pos {
        return ePosInfos.get(node);
    }

    public function getAttrPosition(node:Xml, attr:String):Pos {
        return aPosInfos.get(node).get(attr);
    }

    inline public function sub(xml:Xml):Xml176Document {
    	return new Xml176Document(xml, rawData, ePosInfos, aPosInfos, path);
    }
}

class XmlParserError {
	public var text(default, null):String;
	public var from(default, null):Int;
	public var to(default, null):Int;
	
	public function new(text, from, to) {
		this.text = text;
		this.from = from;
		this.to = to;
	}
}

class Xml176Parser
{
	static public function parse(str:String, path:String)
	{
		var xmlDoc = Xml.createDocument();
        var ePosInfos = new Map<Xml, Pos>();
        var aPosInfos = new Map<Xml, Map<String, Pos>>();

		doParse(str, 0, ePosInfos, aPosInfos, xmlDoc);

		return new Xml176Document(xmlDoc, str, ePosInfos, aPosInfos, path);
	}
	
	static function doParse(str:String, p:Int = 0, ePosInfos:Map<Xml, Pos>, aPosInfos:Map<Xml, Map<String, Pos>>, ?parent:Xml):Int
	{
		var xml:Xml = null;
        var xmlPos:Pos = { from: 0, to: 0 };
		var state = S.BEGIN;
		var next = S.BEGIN;
		var aname = null;
		var start = 0;
		var nsubs = 0;
		var nbrackets = 0;
		var c = str.fastCodeAt(p);
		var buf = new StringBuf();
		while (!StringTools.isEof(c))
		{
			switch(state)
			{
				case S.IGNORE_SPACES:
					switch(c)
					{
						case
							'\n'.code,
							'\r'.code,
							'\t'.code,
							' '.code:
						default:
							state = next;
							continue;
					}
				case S.BEGIN:
					switch(c)
					{
						case '<'.code:
							state = S.IGNORE_SPACES;
							next = S.BEGIN_NODE;
						default:
							start = p;
							state = S.PCDATA;
							continue;
					}
				case S.PCDATA:
					if (c == '<'.code)
					{
						#if php
						var child = Xml.createPCDataFromCustomParser(buf.toString() + str.substr(start, p - start));
						#else
						var child = Xml.createPCData(buf.toString() + str.substr(start, p - start));
						#end
						buf = new StringBuf();
						parent.addChild(child);
						nsubs++;
						state = S.IGNORE_SPACES;
						next = S.BEGIN_NODE;
					}
					#if !flash9
					else if (c == '&'.code) {
						buf.addSub(str, start, p - start);
						state = S.ESCAPE;
						next = S.PCDATA;
						start = p + 1;
					}
					#end
				case S.CDATA:
					if (c == ']'.code && str.fastCodeAt(p + 1) == ']'.code && str.fastCodeAt(p + 2) == '>'.code)
					{
						var child = Xml.createCData(str.substr(start, p - start));
						parent.addChild(child);
						nsubs++;
						p += 2;
						state = S.BEGIN;
					}
				case S.BEGIN_NODE:
					switch(c)
					{
						case '!'.code:
							if (str.fastCodeAt(p + 1) == '['.code)
							{
								p += 2;
								if (str.substr(p, 6).toUpperCase() != "CDATA[")
									throw new XmlParserError("Expected <![CDATA[", p, p + 1);
								p += 5;
								state = S.CDATA;
								start = p + 1;
							}
							else if (str.fastCodeAt(p + 1) == 'D'.code || str.fastCodeAt(p + 1) == 'd'.code)
							{
								if(str.substr(p + 2, 6).toUpperCase() != "OCTYPE")
									throw new XmlParserError("Expected <!DOCTYPE", p, p + 1);
								p += 8;
								state = S.DOCTYPE;
								start = p + 1;
							}
							else if( str.fastCodeAt(p + 1) != '-'.code || str.fastCodeAt(p + 2) != '-'.code )
								throw new XmlParserError("Expected <!--", p, p + 2);
							else
							{
								p += 2;
								state = S.COMMENT;
								start = p + 1;
							}
						case '?'.code:
							state = S.HEADER;
							start = p;
						case '/'.code:
							if( parent == null )
								throw new XmlParserError("Expected node name", p, p + 1);
							start = p + 1;
							state = S.IGNORE_SPACES;
							next = S.CLOSE;
						default:
							state = S.TAG_NAME;
							start = p;
							continue;
					}
				case S.TAG_NAME:
					if (!isValidChar(c))
					{
						if( p == start )
							throw new XmlParserError("Expected node name", p, p + 1);
						xml = Xml.createElement(str.substr(start, p - start));
                        ePosInfos.set(xml, {from:start, to: p});
						parent.addChild(xml);
						state = S.IGNORE_SPACES;
						next = S.BODY;
						continue;
					}
				case S.BODY:
					switch(c)
					{
						case '/'.code:
							state = S.WAIT_END;
							nsubs++;
						case '>'.code:
							state = S.CHILDS;
							nsubs++;
						default:
							state = S.ATTRIB_NAME;
							start = p;
							continue;
					}
				case S.ATTRIB_NAME:
					if (!isValidChar(c))
					{
						var tmp;
						if( start == p )
							throw new XmlParserError("Expected attribute name", p, p + 1);
						tmp = str.substr(start,p-start);
						aname = tmp;
						if( xml.exists(aname) )
							throw new XmlParserError("Duplicate attribute", start, p);
						state = S.IGNORE_SPACES;
						next = S.EQUALS;
						continue;
					}
				case S.EQUALS:
					switch(c)
					{
						case '='.code:
							state = S.IGNORE_SPACES;
							next = S.ATTVAL_BEGIN;
						default:
							throw new XmlParserError("Expected =", p, p + 1);
					}
				case S.ATTVAL_BEGIN:
					switch(c)
					{
						case '"'.code, '\''.code:
							state = S.ATTRIB_VAL;
							start = p;
						default:
							throw new XmlParserError("Expected \"", p, p + 1);
					}
				case S.ATTRIB_VAL:
					if (c == str.fastCodeAt(start))
					{
						var val = str.substr(start+1,p-start-1);
						xml.set(aname, val);

                        var pi = aPosInfos.get(xml);
                        if (pi == null) {
                            pi = new Map<String, Pos>();
                            aPosInfos.set(xml, pi);
                        }
                        pi.set(aname, {from:start-aname.length, to: start});
						state = S.IGNORE_SPACES;
						next = S.BODY;
					}
				case S.CHILDS:
					p = doParse(str, p, ePosInfos, aPosInfos, xml);
					start = p;
					state = S.BEGIN;
				case S.WAIT_END:
					switch(c)
					{
						case '>'.code:
							state = S.BEGIN;
						default :
							throw new XmlParserError("Expected >", p, p + 1);
					}
				case S.WAIT_END_RET:
					switch(c)
					{
						case '>'.code:
							if( nsubs == 0 )
								parent.addChild(Xml.createPCData(""));
							return p;
						default :
							throw new XmlParserError("Expected >", p, p + 1);
					}
				case S.CLOSE:
					if (!isValidChar(c))
					{
						if( start == p )
							throw new XmlParserError("Expected node name", p, p + 1);
							
						var v = str.substr(start,p - start);
						if (v != parent.nodeName)
							throw new XmlParserError("Expected </" +parent.nodeName + ">", start, p);

						state = S.IGNORE_SPACES;
						next = S.WAIT_END_RET;
						continue;
					}
				case S.COMMENT:
					if (c == '-'.code && str.fastCodeAt(p +1) == '-'.code && str.fastCodeAt(p + 2) == '>'.code)
					{
						var xml;
						parent.addChild(xml = Xml.createComment(str.substr(start, p - start)));
						ePosInfos.set(xml, {from:start, to: p});
						p += 2;
						state = S.BEGIN;
					}
				case S.DOCTYPE:
					if(c == '['.code)
						nbrackets++;
					else if(c == ']'.code)
						nbrackets--;
					else if (c == '>'.code && nbrackets == 0)
					{
						parent.addChild(Xml.createDocType(str.substr(start, p - start)));
						state = S.BEGIN;
					}
				case S.HEADER:
					if (c == '?'.code && str.fastCodeAt(p + 1) == '>'.code)
					{
						p++;
						var str = str.substr(start + 1, p - start - 2);
						parent.addChild(Xml.createProcessingInstruction(str));
						state = S.BEGIN;
					}
				case S.ESCAPE:
					if (c == ';'.code)
					{
						var s = str.substr(start, p - start);
						if (s.fastCodeAt(0) == '#'.code) {
							var i = s.fastCodeAt(1) == 'x'.code
								? Std.parseInt("0" +s.substr(1, s.length - 1))
								: Std.parseInt(s.substr(1, s.length - 1));
							buf.add(String.fromCharCode(i));
						} else if (!escapes.exists(s))
							buf.add('&$s;');
						else
							buf.add(escapes.get(s));
						start = p + 1;
						state = next;
					}
			}
			c = str.fastCodeAt(++p);
		}
		
		if (state == S.BEGIN)
		{
			start = p;
			state = S.PCDATA;
		}
		
		if (state == S.PCDATA)
		{
			if (p != start || nsubs == 0)
				parent.addChild(Xml.createPCData(buf.toString() + str.substr(start, p - start)));
			return p;
		}
		
		throw new XmlParserError("Unexpected end", p - 1, p);
	}
	
	static inline function isValidChar(c) {
		return (c >= 'a'.code && c <= 'z'.code) || (c >= 'A'.code && c <= 'Z'.code) || (c >= '0'.code && c <= '9'.code) || c == ':'.code || c == '.'.code || c == '_'.code || c == '-'.code;
	}

    static var escapes = {
        var h = new haxe.ds.StringMap();
        h.set("lt", "<");
        h.set("gt", ">");
        h.set("amp", "&");
        h.set("quot", '"');
        h.set("apos", "'");
        h.set("nbsp", String.fromCharCode(160));
        h;
    }
}

typedef Pos = { from:Int, to:Int }