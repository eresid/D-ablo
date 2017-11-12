module dcore.cel.CelFile;

import dcore.cel.CelDecoder;

/**
 * original file:
 *      celfile.cpp (02.06.2016)
 *      celfile.h (02.06.2016)
 */
class CelFile {

    private CelDecoder decoder;

    this(string filename) {
        decoder = new CelDecoder(filename);
    }

    /+

    // If normal cel file, returns same as numFrames(), for an archive, the number of frames in each subcel
    uint animLength() {
        return decoder.animationLength();
    }

    uint numFrames() {
        return decoder.numFrames();
    }

    CelFrame getCelFrame(uint index) {
        return decoder.getCelFrame(index);
    }+/
}