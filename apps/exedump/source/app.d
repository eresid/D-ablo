module exedump;

import std.stdio;

import components.Settings;
import components.FreeabloIO;
import components.diabloexe.DiabloExe;

/**
 * original file:
 *      exedump/main.cpp (22.08.2015)
 */
void main(string[] args){
    Settings settings = new Settings;
    if (!settings.loadUserSettings()) {
        writeln("Error: cannot load user settings");
        return;
    }

    FreeabloIO faio = new FreeabloIO;
    if (!faio.init(settings.getPathMPQ)) {
        writeln("Error: cannot init FAIO");
        return;
    }

    DiabloExe exe = new DiabloExe(settings.getPathExe);
    writeln(exe.dump());

    faio.quit();
}