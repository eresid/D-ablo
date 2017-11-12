module exedump;

import std.stdio;

import dcore.input.InputManager;
import dcore.nuklearmisc.InputFwd;
import dcore.nuklearmisc.StandaloneGuiSpriteHandler;
import dcore.nuklearmisc.Widgets;
import dcore.render.Render;
import dcore.FreeabloIO;
import dcore.Settings;
//#include <chrono> http://www.cplusplus.com/reference/chrono/
//#include <nfd.h> https://github.com/mlabbe/nativefiledialog

/**
 * original file:
 *      celview/main.cpp (17.10.2017)
 */
void main(string[] args) {

    Render.RenderSettings renderSettings = new Render.RenderSettings;
    renderSettings.windowWidth = 800;
    renderSettings.windowHeight = 600;
    renderSettings.fullscreen = false;

    //NuklearMisc::StandaloneGuiHandler guiHandler("Cel Viewer", renderSettings);

    //nk_context* ctx = guiHandler.getNuklearContext();

    Settings settings = new Settings;
    if (!settings.loadFromFile("resources/celview.ini")) {
        writeln("Error: cannot load settings from file");
        return;
    }

    bool faioInitDone = false;
   // TODO
}
