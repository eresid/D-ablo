module savegame.SaveGameManager;

import std.stdio;

/**
 * original file:
 *      savegamemanager.cpp (30.08.2015)
 *      savegamemanager.h (19.08.2015)
 */
public class SaveGameManager {

    private World mWorld;

    public this(World world) {
        mWorld = world;
    }

    public void save() {
        Player player = mWorld.getCurrentPlayer();

        ofstream saveGameFile(getSaveGamePath());
        if (!saveGameFile.good()) {
            return;
        }

        OutputStream output(saveGameFile);
        int level = mWorld.getCurrentLevelIndex();
        output << level;
        output << *player;
    }

    public bool load() {
        Player player = mWorld.getCurrentPlayer();
        size_t tmpLevel;

        std::ifstream saveGameFile(getSaveGamePath());
        if (!saveGameFile.good()) {
            return false;
        }

        InputStream input(saveGameFile);
        input >> tmpLevel;
        input >> *player;

        mWorld.setLevel(tmpLevel);

        return true;
    }

    private string getSaveGamePath() {
        // TODO: read path from settings after PR #151 merge
        return "savegame.txt";
    }
}