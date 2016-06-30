module components.misc.StringOps;

/**
 * original file:
 *      stringops.h (27.03.2016)
 */
class StringOps {

    extern(C) int isprint(int c) pure nothrow @nogc @trusted;

    static bool containsNonPrint(string s) {
        for (uint i=0; i < s.length(); i++) {
            if (!isprint(s[i])) {
                return true;
            }
        }

        return false;
    }
}