module dcore.Settings;

import std.stdio;
import std.file;
import std.conv;

import dcore.utils.IniParser;

/**
 * original file:
 *      settings.cpp (06.05.2016)
 *      settings.h (16.08.2015)
 */
class Settings {

    private string mPath;
    private Ini mDefaultsPropertyTree;
	private Ini mUserPropertyTree;

	public static immutable string DEFAULT_PATH = "resources/settings-default.ini";
	public static immutable string USER_PATH = "resources/settings-user.ini";
	public static immutable string USER_DIR = "resources/";

	public bool loadUserSettings() {

		// Load defaults

		if (!exists(DEFAULT_PATH)) {
            return false;
		}

        mDefaultsPropertyTree = Ini.Parse(DEFAULT_PATH);

        // Load user settings

        mPath = USER_PATH;

        if (!exists(USER_PATH)) {
            createFile(USER_PATH);
            return true;
        }

        try {
            mUserPropertyTree = Ini.Parse(USER_PATH);
        } catch (Exception e) {
            writeln("Loading INI exception: ", e.msg);
            return false;
        }

		return true;
	}

	public bool loadFromFile(immutable string path) {

        if (!exists(path)) {
            writeln("Settings file \"%s\" does not exists. Creating file...", path);
            createFile(path);
        }

        mPath = path;

        try {
           mUserPropertyTree = Ini.Parse(USER_PATH);
        } catch (Exception e) {
           writeln("Loading INI exception: ", e.msg);
           return false;
        }

        return true;
	}

    private void createFile(immutable string path) {
        import std.exception : ErrnoException;

        try {
            copy(DEFAULT_PATH, USER_PATH);
        } catch (ErrnoException ex) {
            writeln("Cannot create file: %s\n%s", path, ex.msg);
        }
    }

	public bool save() {
	    import std.array;

        if (mPath.empty) {
            writeln("Settings file is not set.");
            return false;
        }

        mUserPropertyTree.save(mPath);

        return true;
	}

	public int getResolutionWidth() {
        return to!int(mUserPropertyTree["Display"].getKey("resolutionWidth"));
	}

	public int getResolutionHeight() {
        return to!int(mUserPropertyTree["Display"].getKey("resolutionHeight"));
    }

    public bool isFullScreen() {
        return to!bool(mUserPropertyTree["Display"].getKey("fullscreen"));
    }

    public string getPathExe() {
        if (mUserPropertyTree["Game"].hasKey("PathEXE")) {
            return mUserPropertyTree["Game"].getKey("PathEXE");
        } else {
            return null;
        }
    }

    public string getPathMPQ() {
        if (mUserPropertyTree["Game"].hasKey("PathMPQ")) {
            return mUserPropertyTree["Game"].getKey("PathMPQ");
        } else {
            return null;
        }
    }

    public bool showTitleScreen() {
        return to!bool(mUserPropertyTree["Game"].getKey("showTitleScreen"));
    }
}

unittest {
    Settings settings = new Settings;
    assert(settings.loadUserSettings());

    testSettings(settings);
}

unittest {
    string filename = Settings.USER_PATH;

    Settings settings = new Settings;
    assert(settings.loadUserSettings());

    remove(filename);

    assert(!exists(filename));
    assert(settings.save());
    assert(exists(filename));
    assert(settings.loadUserSettings());

    testSettings(settings);
}

private void testSettings(Settings settings) {
    assert(settings.getResolutionWidth() == 1280);
    assert(settings.getResolutionHeight() == 960);
    assert(settings.isFullScreen() == true);
    assert(settings.showTitleScreen() == true);
    assert(settings.getPathExe() is null);
    assert(settings.getPathMPQ() is null);
}