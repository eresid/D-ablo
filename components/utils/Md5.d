module components.utils.Md5;

import std.digest.md;
import std.uni;
import std.stdio;
import std.file;

class Md5 {

    private static Md5 mInstance;

    private MD5Digest md5;

    private this() {
        md5 = new MD5Digest;
    }

    public static synchronized Md5 getInstance() {
        if (mInstance is null) {
            mInstance = new Md5;
        }

        return mInstance;
    }

    public string fromString(string value) {
        ubyte[] hash = md5.digest(value);
        return toHexString(hash).toLower;
    }

    public string fromFile(string value) {
        if (!exists(value)) {
            return null;
        }

        File file = File(value, "r");

        // As digests implement OutputRange, we could use std.algorithm.copy
        // Let's do it manually for now
        foreach (buffer; file.byChunk(4096 * 1024)) {
            md5.put(buffer);
        }

        ubyte[] result = md5.finish();
        file.close();

        return toHexString(result).toLower;
    }
}

unittest {
    assert(Md5.getInstance().fromString("abc") == "900150983cd24fb0d6963f7d28e17f72");
    assert(Md5.getInstance().fromString("abc123") == "e99a18c428cb38d5f260853678922e03");
}

unittest {
    string testFile = "test.txt";

    removeFile(testFile);

    assert(Md5.getInstance().fromFile(testFile) is null);
    File file = File(testFile, "w");
    file.writeln("hello");
    file.close();
    file = File(testFile, "r");

    assert(Md5.getInstance().fromFile(testFile) !is null);
    assert(Md5.getInstance().fromFile(testFile) == "b1946ac92492d2347c6235b4d2611184");

    removeFile(testFile);
}

private void removeFile(string file) {
    if (exists(file)) {
        remove(file);
    }
}