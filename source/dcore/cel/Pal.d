module dcore.cel.Pal;

import std.stdio;

import dcore.faio.FreeabloIO;

struct Colour {
    ubyte r;
    ubyte g;
    ubyte b;
    bool visible = true;

    this(ubyte _r, ubyte _g, ubyte _b, bool _visible) {
        r = _r;
        g = _g;
        b = _b;
        visible = _visible;
    }
}

/**
 * original file:
 *      pal.cpp (02.06.2016)
 *      pal.h (02.06.2016)
 */
class Pal {

    private static immutable CONTENTS_SIZE = 256;

    private Colour[] contents;

    this() {
        contents.length = CONTENTS_SIZE;
    }

    this(string filename) {
        this();

        FreeabloIO faio = new FreeabloIO();
        if (!faio.init(filename)) {
            writeln("Error: cannot init FAIO");
            return;
        }
        FAFile palFile = faio.fileOpen(filename);

        for (int i = 0; i < CONTENTS_SIZE; i++) {
            //faio.fileRead(contents[i].r, 1, 1, palFile);
            //faio.fileRead(contents[i].g, 1, 1, palFile);
            //faio.fileRead(contents[i].b, 1, 1, palFile);
        }

        faio.fileClose(palFile);
    }

    const Colour getColour(uint index) {
        return contents[index];
    }
}