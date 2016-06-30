module render.RenderState;

import world.Position;

class RenderState {

    struct Group {
        SpriteGroup group;
        int indexIntoGroup;
        Position position;
    }

    public synchronized bool ready;

    public Position mPos;

    public Group[] mObjects;

    public DrawCommand[] guiDrawBuffer;

    public Tileset tileset;

    public GameLevel level;

    public SpriteGroup mCursorSpriteGroup;

    public int mCursorFrame;

    public bool mCursorEmpty;

    public this() {
        ready = true;
    }
}