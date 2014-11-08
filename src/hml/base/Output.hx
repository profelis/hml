package hml.base;


typedef Output = {
    path:String, // output folder path
    ?autoClear:Bool, // empty output folder before generate output: default false
    ?autoCreate:Bool, // create output folder if expected: default true
    ?allowOverride:Bool // allow override files in output folder: default true
}