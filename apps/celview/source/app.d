module exedump;

import std.stdio;

import components.input.InputManager;
import components.nuklearmisc.InputFwd;
import components.nuklearmisc.StandaloneGuiSpriteHandler;
import components.nuklearmisc.Widgets;
import components.render.Render;
import components.FreeabloIO;
import components.Settings;
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
