module components.cel.CelFrame;

import components.cel.Pal;

/**
 * original file:
 *      celframe.cpp (02.06.2016)
 *      celframe.h (02.06.2016)
 */
class CelFrame {

    private Colour mColour;
    private CelFile mCelFile;

    uint mWidth;
    uint mHeight;

    private Colour[] mRawImage;

   // CelFrame[Colour] getFrame(uint x) {
   //     return this[getColour];
   //     //return Misc::Helper2D<const CelFrame, const Colour&>(*this, x, getColour);
   // }

    Colour getColour(uint x, uint y, CelFrame frame) {
        return frame.mRawImage[x + ((frame.mHeight - 1 - y) * frame.mWidth)];
    }
}