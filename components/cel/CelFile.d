module components.cel.CelFile;

/**
 * original file:
 *      celfile.cpp (02.06.2016)
 *      celfile.h (02.06.2016)
 */
class CelFile {

    private CelDecoder mDecoder;

    this(string filename) {
        mDecoder = new CelDecoder(filename);
    }

    // If normal cel file, returns same as numFrames(), for an archive, the number of frames in each subcel
    uint animLength() {
        return mDecoder.animationLength();
    }

    uint numFrames() {
        return mDecoder.numFrames();
    }

    CelFrame getCelFrame(uint index) {
        return mDecoder.getCelFrame(index);
    }
}