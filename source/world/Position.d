module world.Position;

import std.typecons;

/**
 * original file:
 *      position.cpp (01.01.2016)
 *      position.h (01.01.2016)
 */
public class Position { // TODO extend NetObject

    alias CurrentPosition = Tuple!(int, "x", int, "y");

    private CurrentPosition mCurrent;

    ///< percentage of the way there
    public int mDist;
    public int mDirection;
    public bool mMoving;

    public this() {
        this(0, 0, 0);
    }

    public this(int x, int y) {
        this(x, y, 0);
    }

    public this(int x, int y, int direction) {
        mCurrent.x = 0;
        mCurrent.y = 0;
        mDirection = direction;
    }

    ///< advances towards mNext
    public void update() {
        if (mMoving) {
            mDist += 2;

            if (mDist >= 100) {
                mCurrent = next();
                mDist = 0;
            }
        }
    }

    ///< where we are coming from
    public CurrentPosition getCurrent() {
        return mCurrent;
    }

    ///< where we are going to
    public CurrentPosition next() {
        if (!mMoving) {
            return mCurrent;
        }

        CurrentPosition retval = mCurrent;

        switch(mDirection) {
            case 0: {
                retval.x++;
                retval.y++;
                break;
            }
            case 7: {
                retval.x++;
                break;
            }
            case 6: {
                retval.x++;
                retval.y--;
                break;
            }
            case 5: {
                retval.y--;
                break;
            }
            case 4: {
                retval.x--;
                retval.y--;
                break;
            }
            case 3: {
                retval.x--;
                break;
            }
            case 2: {
                retval.x--;
                retval.y++;
                break;
            }
            case 1: {
                retval.y++;
                break;
            }
            default: {
                break;
            }
        }

        return retval;
    }

    public double distanceFrom(Position position) {
        import std.math;

        int dx = mCurrent.x - position.getCurrent().x;
        int dy = mCurrent.y - position.getCurrent().y;

        double x = pow(dx, 2.0);
        double y = pow(dy, 2.0);
        double distance = sqrt(x + y);

        return distance;
    }
}