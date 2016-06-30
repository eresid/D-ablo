module main;

/**
 * original file: 05.05.2016
 */
void main(string[] args) {
    import std.stdio: writeln;
    import components.Settings;
    import components.FreeabloIO;
    //import gameengine.EngineMain;

	Settings settings = new Settings;
	if (!settings.loadUserSettings()) {
	    writeln("Error: cannot load user settings");
		return;
	}

    FreeabloIO faio = new FreeabloIO;
    if (!faio.init(settings.getPathMPQ())) {
        writeln("Error: cannot init FAIO");
        return;
    }

    string[string] variables;
    try {
        variables = parseOptions(args);
    } catch (Exception e) {
        writeln("Error: ", e.msg);
        return;
    }

    //EngineMain engine = new EngineMain;
    //engine.run(settings, variables);

    faio.quit();
}

string[string] parseOptions(string[] args) {
    import std.getopt;
    import std.conv;

    int level = -1;
    string character = "Warrior";
    string mode = "server";

    auto options = getopt(args,
        "level|l", "Level number to load (0-16)", &level,
        "character|c", "Choose Warrior, Rogue or Sorcerer", &character,
        "mode|m", "Choose server or client mode", &mode
    );

    if (options.helpWanted) {
        defaultGetoptPrinter("Help", options.options);
    }

    if (level > 16) {
        throw new Exception("There is no level after 16");
    }

    string[string] variables;
    variables["level"] =  to!string(level);
    variables["character"] = character;
    variables["mode"] = mode;

    return variables;
}

unittest {
    auto args = ["freeablo", "--level", "5", "--character", "Rogue", "--mode", "client"];
    testData(args, "5", "Rogue", "client");
}

unittest {
    auto args = ["freeablo"];
    testData(args, "-1", "Warrior", "server");
}

unittest {
    auto args = ["freeablo", "--level", "20"];
    testException(args, "There is no level after 16");
}

unittest {
    auto args = ["freeablo", "--incoddectkey"];
    testException(args, "Unrecognized option --incoddectkey");
}

void testException(string[] args, string errorMessage) {
    string[string] variables;
    try {
        variables = parseOptions(args);
        assert(false);
    } catch (Exception e) {
        assert(e.msg == errorMessage);
    }
}

void testData(string[] args, string level, string character, string mode) {
    string[string] variables;
    try {
        variables = parseOptions(args);
    } catch (Exception e) {
        assert(false);
    }

    assert(variables["level"] == level);
    assert(variables["character"] == character);
    assert(variables["mode"] == mode);
}
