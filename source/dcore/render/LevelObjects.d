module dcore.render.LevelObjects;

/**
 * original file:
 *      levelobjects.cpp (26.04.2014)
 *      levelobjects.h (04.01.2015)
 */
public class LevelObjects {

    struct LevelObject {
        bool valid;
        real spriteCacheIndex;
        real spriteFrame;
        int x2;
        int y2;
        int dist;
    }

    private LevelObject[] mData;
    private real mWidth;
    private real mHeight;

    public void resize(real x, real y) {
        mData.resize(x * y);
        mWidth = x;
        mHeight = y;
    }

    private LevelObject get(real x, real y, LevelObjects objects) {
        return objects.mData[x + y * objects.mWidth];
    }

//    public Misc::Helper2D<LevelObjects, LevelObject> operator[] (real x) {
//        return Misc::Helper2D<LevelObjects, LevelObject&>(*this, x, get);
//    }

    public real width() {
        return mWidth;
    }

    public real height() {
        return mHeight;
    }
}