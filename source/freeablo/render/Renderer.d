module render.Renderer;

import core.sync.mutex;

import gameengine.ThreadManager;

class Renderer {

    alias TilePosition = Tuple!(int, "x", int, "y");

    private static Renderer mInstance;

    private synchronized bool mDone;
    private Render.LevelObjects mLevelObjects;

    private RenderState mStates[15];

    private Rocket.Core.Context mRocketContext;

    private SpriteManager mSpriteManager;

    private synchronized bool mAlreadyExited = false;
    private Mutex mDoneMutex;
    // TODO private std::condition_variable mDoneCV;

    private this(int windowWidth = 1280, int windowHeight = 960, bool fullscreen = true) {
        Render.RenderSettings settings;
        settings.windowWidth = windowWidth;
        settings.windowHeight = windowHeight;
        settings.fullscreen = fullscreen;

        Render.init(settings);

        // TODO
    }

    public static synchronized Renderer getInstance() {
        if (mInstance is null) {
            mInstance = new Renderer;
        }

        return mInstance;
    }

    public void destroy() {

    }

    public void stop() {
        mDone = true;
    }

    public void waitUntilDone() {
//        std::unique_lock<std::mutex> lk(mDoneMutex);
//
//        if (!mAlreadyExited) {
//            mDoneCV.wait(lk);
//        }
    }

    public Tileset getTileset(GameLevel gameLevel) {
        Level level = gameLevel.mLevel;

        Tileset tileset;
        tileset.minTops = mSpriteManager.getTileset(level.getTileSetPath(), level.getMinPath(), true);
        tileset.minBottoms = mSpriteManager.getTileset(level.getTileSetPath(), level.getMinPath(), false);

        return tileset;
    }

    // ooh ah up de ra
    public RenderState getFreeState() {
        for (int i = 0; i < 15; i++) {
            if (mStates[i].ready) {
                mStates[i].ready = false;
                return mStates[i];
            }
        }

        return null;
    }

    public void setCurrentState(RenderState current) {
        ThreadManager.getInstance().sendRenderState(current);
    }

    public SpriteGroup loadImage(string path) {
        return mSpriteManager.get(path);
    }

    public SpriteGroup loadServerImage(int index) {
        return mSpriteManager.getByServerSpriteIndex(index);
    }

    public void fillServerSprite(int index, string path) {
        mSpriteManager.fillServerSprite(index, path);
    }

    public string getPathForIndex(int index) {
        return mSpriteManager.getPathForIndex(index);
    }

    public TilePosition getClickedTile(int x, int y, const GameLevel level, const Position screenPos) {
        return Render.getClickedTile(level.mLevel, x, y, screenPos.current().first, screenPos.current().second,
                                      screenPos.next().first, screenPos.next().second, screenPos.mDist);
    }

    public Rocket.Core.Context getRocketContext() {
        return mRocketContext;
    }

    public void setCursor(RenderState state) {
        if (!State.mCursorEmpty) {
            Render.Sprite sprite = mSpriteManager.get(State.mCursorSpriteGroup.getCacheIndex()).operator [](State.mCursorFrame);
            Render.drawCursor(sprite, State.mCursorSpriteGroup.getWidth(), State.mCursorSpriteGroup.getHeight());
        } else {
            Render.drawCursor(null);
        }

        return;
    }

    ///< To be called only by Engine::ThreadManager
    public bool renderFrame(RenderState state) {
        if (mDone) {
            {
                std::unique_lock<std::mutex> lk(mDoneMutex);
                mAlreadyExited = true;
            }

            mDoneCV.notify_one();
            return false;
        }

        if (state) {
            if(state.level) {
                if (mLevelObjects.width() != state.level.width() || mLevelObjects.height() != state.level.height())
                    mLevelObjects.resize(state.level.width(), state.level.height());

                for(int x = 0; x < mLevelObjects.width(); x++)
                {
                    for(int y = 0; y < mLevelObjects.height(); y++)
                    {
                        mLevelObjects[x][y].valid = false;
                    }
                }

                for(int i = 0; i < state->mObjects.size(); i++)
                {
                    Position position = state.mObjects[i];

                    int x = position.current().x;
                    int y = position.current().y;

                    mLevelObjects[x][y].valid = std::get<0>(state->mObjects[i]).isValid();
                    mLevelObjects[x][y].spriteCacheIndex = std::get<0>(state.mObjects[i]).getCacheIndex();
                    mLevelObjects[x][y].spriteFrame = std::get<1>(state.mObjects[i]);
                    mLevelObjects[x][y].x2 = position.next().x;
                    mLevelObjects[x][y].y2 = position.next().y;
                    mLevelObjects[x][y].dist = position.mDist;
                }

                Render::drawLevel(state->level->mLevel, state->tileset.minTops->getCacheIndex(), state->tileset.minBottoms->getCacheIndex(), &mSpriteManager, mLevelObjects, state->mPos.current().first, state->mPos.current().second,
                    state->mPos.next().first, state->mPos.next().second, state->mPos.mDist);
            }

            Render::drawGui(state->guiDrawBuffer, &mSpriteManager);
            Renderer::setCursor(state);
        }

        Render::draw();

        return true;
    }

    ///< To be called only by Engine::ThreadManager
    public void cleanup() {
        mSpriteManager.clear();
    }

    private bool loadGuiTextureFunc(Rocket::Core::TextureHandle& texture_handle, Rocket::Core::Vector2i& texture_dimensions, const Rocket::Core::String& source);
    private bool generateGuiTextureFunc(Rocket::Core::TextureHandle& texture_handle, const Rocket::Core::byte* source, const Rocket::Core::Vector2i& source_dimensions);
    private void releaseGuiTextureFunc(Rocket::Core::TextureHandle texture_handle);
}