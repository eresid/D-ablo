module levelgen.LevelGen;

import components.misc.Misc;

/**
 * original file:
 *      levelgen.cpp (11.04.2016)
 *      levelgen.h (12.12.2015)
 */
class LevelGen {

    // the values here are not significant, these were just conventient when debugging level 3
    // they must only be distinct
    enum Basic {
        insideWall = 27,
        wall = 56,
        upStairs = 35,
        downStairs = 34,
        door = 67,
        floor = 116,
        blank = 115
    }

    GameLevel generate(real width, real height, int dLvl, const DiabloExe exe, real previous, real next) {

    }
}