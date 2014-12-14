package hml.base;


typedef Output = {
    path:String, // output folder path
    ?autoClear:Bool, // remove un-updated files/empty subfolders from output folder: default true
    ?autoCreate:Bool, // create output folder if expected: default true
    ?allowOverride:Bool // allow override files in output folder: default true
}