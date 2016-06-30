module gameengine.EngineInputManager;

import std.stdio;

import gameengine.InputObserverInterface;

/**
 * original file:
 *      engineinputmanager.cpp (06.06.2016)
 *      engineinputmanager.h (06.06.2016)
 */
class EngineInputManager {

    alias KeyboardInputAction = InputObserverInterface.Point;

    // private World mWorld;

    private InputManager mInput;
    private bool mToggleConsole = false;
    private Point mMousePosition;
    private bool mMouseDown = false;
    private bool mClick = false;

    private KeyboardInputAction[Hotkey] mHotkeys;
    private KeyboardInputObserverInterface[] mKeyboardObservers;
    private MouseInputObserverInterface[] mMouseObservers;

    public this() {

    }

    public void update(bool paused) {

    }

    public Hotkey[] getHotkeys() {

    }

    public void registerKeyboardObserver(KeyboardInputObserverInterface observer) {

    }

    public void registerMouseObserver(MouseInputObserverInterface observer) {

    }

    public void setHotkey(KeyboardInputAction action, Hotkey hotkey) {
        mHotkeys[action] = hotkey;
    }

    public Hotkey getHotkey(KeyboardInputAction action) {
        return mHotkeys[action];
    }

    private void keyPress(Key key) {

    }

    private void mouseClick(ulong x, ulong y, Key key) {

    }

    private void mouseRelease(ulong, ulong, Key key) {

    }

    private void mouseMove(ulong x, ulong y) {

    }

    private string keyboardActionToString(KeyboardInputAction action) {

    }

    private void notifyKeyboardObservers(KeyboardInputAction action) {

    }

    private void notifyMouseObservers(MouseInputAction action, Point mousePosition) {

    }
}