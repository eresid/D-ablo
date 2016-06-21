module gameengine.EngineMain;

import components.Settings;

import gameengine.InputObserverInterface;
import gameengine.ThreadManager;
import gameengine.EngineInputManager;
import render.RenderState;
import render.Renderer;

/**
 * original file:
 *      enginemain.cpp (06.06.2016)
 *      enginemain.h (06.06.2016)
 */
public class EngineMain {

    alias KeyboardInputAction = InputObserverInterface.KeyboardInputAction;

//    private Level mLevel;
//    private World mWorld;
//    private DiabloExe mDiabloExe;
    private EngineInputManager mInputManager;

    private bool mDone = false;
    private bool mPaused = false;
    private bool mNoclip = false;

//    private synchronized bool renderDone = false;

//    public EngineInputManager inputManager() {
//        return mInputManager;
//    }

    public void run(Settings settings, string[string] variables) {
        int resolutionWidth = settings.getResolutionWidth();
        int resolutionHeight = settings.getResolutionHeight();
        bool isFullScreen = settings.isFullScreen();
        string pathExe = settings.getPathExe();
        if (pathExe == "") {
            pathExe = "Diablo.exe";
        }

        Renderer renderer(resolutionWidth, resolutionHeight, fullscreen == "true");
        mInputManager = new EngineInputManager;
        mInputManager.registerKeyboardObserver(this);

        Thread thread = new Thread({
            runGameLoop(settings, variables, pathExe);
        });
        thread.start();

        ThreadManager.getInstance.run();
        renderDone = true;

        thread.join();
    }

    private void runGameLoop(Settings settings, string[string] variables, string pathExe) {
        // TODO LevelGen::FAsrand(time(null));
        import std.conv;

        Player player;
        Renderer renderer = Renderer.getInstance();

        string characterClass = variables["character"];

        DiabloExe exe = new DiabloExe(pathExe);
        if (!exe.isLoaded()) {
            renderer.stop();
            return;
        }

        ItemManager itemManager = ItemManager.getInstance();
        World world = new World(exe);
        PlayerFactory playerFactory = new PlayerFactory(exe);

        bool isServer = variables["mode"] == "server";
        if (isServer) {
            world.generateLevels();
        }

        itemManager.loadItems(exe);
        player = playerFactory.create(characterClass);
        world.addCurrentPlayer(player);
        world.generateLevels();
        mInputManager.registerKeyboardObserver(world);
        mInputManager.registerMouseObserver(world);

        int currentLevel = to!int(variables["level"]);

        GuiManager guiManager = new GuiManager(player.mInventory, this, characterClass);

        // -1 represents the main menu
        if (currentLevel != -1 && isServer) {
            world.setLevel(currentLevel);

            GameLevel level = world.getCurrentLevel();

            player.mPos = Position(level.upStairsPos().x, level.upStairsPos().y);
            guiManager.showIngameGui();
        } else {
            pause();

            if (settings.showTitleScreen()) {
                guiManager.showTitleScreen();
            } else {
                guiManager.showMainMenu();
            }
        }

        // Main game logic loop
        while(!mDone) {
            mInputManager.update(mPaused);
            if (!mPaused) {
                world.update(mNoclip);
            }

            netManager.update();
            guiManager.update(mPaused);

            GameLevel level = world.getCurrentLevel();
            RenderState state = renderer.getFreeState();
            if (state) {
                state.mPos = player.mPos;
                if (level !is null) {
                    state.tileset = renderer.getTileset(level);
                }
                state.level = level;
                if(!FAGui::cursorPath.empty())
                    state.mCursorEmpty = false;
                else
                    state.mCursorEmpty = true;
                state.mCursorFrame = FAGui::cursorFrame;
                state.mCursorSpriteGroup = renderer.loadImage("data/inv/objcurs.cel");
                world.fillRenderState(state);
                Render::updateGuiBuffer(state.guiDrawBuffer);
            } else {
                Render::updateGuiBuffer(null);
            }
            renderer.setCurrentState(state);

            long remainingTickTime = timer.expires_from_now().total_milliseconds();

            if (remainingTickTime < 0) {
                writeln("tick time exceeded by %s ms", -remainingTickTime);
            }

            timer.wait();
        }

        renderer.stop();
        renderer.waitUntilDone();
    }

    public void notify(KeyboardInputAction action) {
        if (action == KeyboardInputAction.QUIT) {
            stop();
        } else if (action == KeyboardInputAction.NOCLIP) {
            toggleNoclip();
        }
    }

    public void stop() {
        mDone = true;
    }

    public void pause() {
        mPaused = true;
    }

    public void unPause() {
        mPaused = false;
    }

    public void toggleNoclip() {
        mNoclip = !mNoclip;
    }
}