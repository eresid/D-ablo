module dcore.cel.CelDecoder;

import std.uni;
import std.array : split;

import dcore.Settings;
import dcore.cel.Pal;

/**
 * original file:
 *      celdecoder.cpp (06.06.2016)
 *      celdecoder.h (06.06.2016)
 */
class CelDecoder {

    alias FrameBytesRef = ubyte[];
    alias FrameDecoder = CelDecoder!(FrameBytesRef, Pal, Colour[]);
    // TODO typedef std::function<void(CelDecoder&, FrameBytesRef, const Pal, Colour[])> FrameDecoder;

    private ubyte[] mFrames;
    private uint[CelFrame] mCache;
    private string mCelPath;
    private string mCelName;
    private Pal mPal;
    private bool mIsCl2;
    private bool mIsObjcursCel;
    private bool mIsCharbutCel;
    private int mImageCount;
    private int mFrameWidth;
    private int mFrameHeight;
    private int mHeaderSize;
    private uint mAnimationLength;
    private static Settings mSettingsCel;
    private static Settings mSettingsCl2;

    this(string celPath) {
        mCelPath = celPath;
        mAnimationLength = 0;

        readCelName();
        readConfiguration();
        readPalette();
        getFrames();
    }

    void decode() {

    }

    CelFrame getCelFrame(uint index) {
        import std.algorithm: canFind;

        if (mCache.canFind(index)) {
            return mCache[index];
        }

        auto frame = mFrames[index];
        CelFrame celFrame;
        decodeFrame(index, frame, celFrame);
        mCache[index] = celFrame;

        return mCache[index];
    }

    uint numFrames() {
        return mFrames.length;
    }

    uint animationLength() {
        return mAnimationLength;
    }

    // PRIVATE

    private void readConfiguration() {
        static bool isConfigurationRead = false;

        if (!isConfigurationRead) {
            mSettingsCel.loadFromFile("resources/cel.ini");
            mSettingsCl2.loadFromFile("resources/cl2.ini");
            isConfigurationRead = true;
        }

        Settings settings = mSettingsCel;
        string celNameWithoutExtension = mCelName;
        string extension = "cel";

        if (mCelPath.endsWith("cl2")) {
            settings = mSettingsCl2;
            extension = "cl2";
            mIsCl2 = true;
        }

        uint pos = celNameWithoutExtension.find_last_of(extension) - 3;
        celNameWithoutExtension = celNameWithoutExtension.substr(0, pos);

        // If more than one image in cel
        // read configuration from first image
        // (temporary solution)

        mImageCount = settings->get<int>(celNameWithoutExtension, "image_count");
        if (mImageCount > 0) {
            celNameWithoutExtension += "0";
        }

        mFrameWidth = settings->get<int>(celNameWithoutExtension, "width");
        mFrameHeight= settings->get<int>(celNameWithoutExtension, "height");
        mHeaderSize = settings->get<int>(celNameWithoutExtension, "header_size", 0);
        mIsObjcursCel = mCelName == "objcurs.cel";
        mIsCharbutCel = mCelName == "charbut.cel";
    }

    private void readCelName() {
        if (mCelPath == null || mCelPath.length == 0) {
            throw "Cel path is empty";
        }

        string[] celPathComponents;

        if(mCelPath.indexOf("/")) {
            celPathComponents = split(mCelPath, '/');
        } else {
            celPathComponents = split(mCelPath, '\\');
        }

        mCelName = celPathComponents[celPathComponents.size() - 1].toLower;
    }

    private void readPalette();

    private void getFrames();

    private void decodeFrame(uint index, FrameBytesRef frame, CelFrame& celFrame);

    private FrameDecoder getFrameDecoder(string celName, FrameBytesRef frame, int frameNumber) {
        import std.algorithm: canFind;

        string[] filenames = { "l1.cel", "l2.cel", "l3.cel", "l4.cel", "town.cel" };

        if (filenames.canFind(celName)) {
            switch(frame.length) {
            case 0x400:
                if(isType0(celName, frameNumber))
                    return &CelDecoder::decodeFrameType0;
                break;
            case 0x220:
                if (isType2or4(frame)) {
                    return &CelDecoder::decodeFrameType2;
                } else if(isType3or5(frame)) {
                    return &CelDecoder::decodeFrameType3;
                }
            case 0x320:
                if (isType2or4(frame)) {
                    return &CelDecoder::decodeFrameType4;
                } else if(isType3or5(frame)) {
                    return &CelDecoder::decodeFrameType5;
                }
            }
        } else if (celName.endsWith("cl2")) {
            return CelDecoder::decodeFrameType6;
        }

        return &CelDecoder::decodeFrameType1;
    }

    private bool isType0(string celName, int frameNumber);

    private bool isType2or4(FrameBytesRef frame);

    private bool isType3or5(FrameBytesRef frame);

    private void decodeFrameType0(FrameBytesRef frame, Pal pal, Colour[] decodedFrame);

    private void decodeFrameType1(FrameBytesRef frame, Pal pal, Colour[] decodedFrame);

    private void decodeFrameType2(FrameBytesRef frame, Pal pal, Colour[] decodedFrame);

    private void decodeFrameType3(FrameBytesRef frame, Pal pal, Colour[] decodedFrame);

    private void decodeFrameType4(FrameBytesRef frame, Pal pal, Colour[] decodedFrame);

    private void decodeFrameType5(FrameBytesRef frame, Pal pal, Colour[] decodedFrame);

    private void decodeFrameType6(FrameBytesRef frame, Pal pal, Colour[] decodedFrame);

    private void decodeFrameType2or3(FrameBytesRef frame, Pal pal, Colour[] decodedFrame, bool frameType2);

    private void decodeFrameType4or5(FrameBytesRef frame, Pal pal, Colour[] decodedFrame, bool frameType4);

    private void decodeLineTransparencyLeft(ubyte framePtr, Pal pal, Colour[] decodedFrame, int);

    private void decodeLineTransparencyRight(ubyte framePtr, Pal pal, Colour[] decodedFrame, int) {
         int transparentCount = 32 - regularCount;

        // Explicit regular pixels.
        for (int i = 0; i < regularCount; i++) {
            Colour color = pal[framePtr[0]];
            decodedFrame[decodedFrame.length] = color;
            framePtr++;
        }

        // Transparent pixels.
        for (int i = 0 ; i < transparentCount; i++) {
            decodedFrame[decodedFrame.length] = Colour(0,0,0,false);
        }
    }

    private void setObjcursCelDimensions(int frameNumber) {
        mFrameWidth = 56;
        mFrameHeight = 84;

        // Width
        if (frameNumber == 0) {
            mFrameWidth = 33;
        } else if (frameNumber > 0 && frameNumber <10) {
            mFrameWidth = 32;
        } else if (frameNumber == 10) {
            mFrameWidth = 23;
        } else if (frameNumber > 10 && frameNumber < 86) {
            mFrameWidth = 28;
        } else if (frameNumber >= 86 && frameNumber < 111) {
            mFrameWidth = 56;
        }

        // Height
        if (frameNumber == 0) {
            mFrameHeight = 29;
        } else if (frameNumber > 0 && frameNumber <10) {
            mFrameHeight = 32;
        } else if (frameNumber == 10) {
            mFrameHeight = 35;
        } else if (frameNumber >= 11 && frameNumber < 61) {
            mFrameHeight = 28;
        } else if (frameNumber >= 61 && frameNumber < 67) {
            mFrameHeight = 56;
        } else if (frameNumber >= 67 && frameNumber < 86) {
            mFrameHeight = 84;
        } else if (frameNumber >= 86 && frameNumber < 111) {
            mFrameHeight = 56;
        }
    }

    private void setCharbutCelDimensions(int frameNumber) {
        mFrameWidth = 41;

        if (frameNumber == 0) {
            mFrameWidth = 95;
        }
    }
}