package hml.base.fileProcessor;

import hml.Hml.Output;

interface IWriter<T> {
    public function write(types:Array<T>, output:Output):Void;
}