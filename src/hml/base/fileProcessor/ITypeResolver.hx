package hml.base.fileProcessor;

interface ITypeResolver<B, T> {
    public function resolve(data:Array<B>):Array<T>;
}