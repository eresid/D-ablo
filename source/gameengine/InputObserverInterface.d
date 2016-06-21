module gameengine.InputObserverInterface;

import std.stdio;

/**
 * original file:
 *      inputobserverinterface.h (31.05.2016)
 */
public class InputObserverInterface {

    enum KeyboardInputAction {
        QUIT,
        NOCLIP,
        CHANGE_LEVEL_DOWN,
        CHANGE_LEVEL_UP,
        TOGGLE_CONSOLE,
        KEYBOARD_INPUT_ACTION_MAX
    }

    enum MouseInputAction {
        MOUSE_RELEASE,
        MOUSE_DOWN,
        MOUSE_CLICK
    }

    class Point {
        ulong x;
        ulong y;

        this() {
            this(0, 0);
        }

        this(ulong x, ulong y) {
            this.x = x;
            this.y = y;
        }
    }

    interface KeyboardInputObserverInterface {
        public void notify(KeyboardInputAction action);
    }

    interface MouseInputObserverInterface {
        public void notify(MouseInputAction action, Point mousePosition);
    }
}