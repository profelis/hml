## hml
===

[![Build Status](https://travis-ci.org/profelis/hml.svg?branch=master)](https://travis-ci.org/profelis/hml)

===
## Magic namespace `xmlns:haxe="http://haxe.org/"`

Root node children

Tag          | Description   | Example
------------ | ------------- | -------------
`<Implements>` | List of interfaces | `<haxe:Implements><![CDATA[foo.IBar]]></haxe:Implements>`
`<Declarations> | <Public>` | List of public declarations | `<haxe:Declarations><ui:String id="string2">"ab"</ui:String></haxe:Declarations>`
`<Private>` | List of private declarations | `<haxe:Private><ui:String id="privateString">'text in private string'</ui:String></haxe:Private>`
`<Script>` | Haxe script block | `<haxe:Script><![CDATA[import flash.display.Sprite;]]></haxe:Script>`

All tags

Tag          | Description   | Example
------------ | ------------- | -------------
`<Meta>` | Metadata | `<haxe:Meta><![CDATA[@FooMeta]]></haxe:Meta>`
`<Generic>` | Type Parameters | `<haxe:Generic><![CDATA[foo.IBar]]></haxe:Generic>`
