package hml.base.fileProcessor;

import hml.Hml.Output;
import hml.base.IFileProcessor;

interface IWriter<T> {
    public function write(types:Array<T>, output:Output):WriterResult;
}