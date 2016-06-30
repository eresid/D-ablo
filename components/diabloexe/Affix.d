module components.diabloexe.Affix;

import components.FreeabloIO;

/**
 * Affix -- Part of a word or phrase can be before or after the object Prefix for before Suffix for afterwords.
 *
 * original file:
 *      affix.cpp (16.08.2015)
 *      affix.h (30.08.2015)
 */
struct Affix {
    string mName;

    uint mEffect;
    uint mMinEffect;
    uint mMaxEffect;
    uint mQualLevel;
    ubyte mBowjewelProb;
    ubyte mWSProb;
    ubyte mASProb;
    ubyte mUnknown0;
    uint mExcludedCombination0;
    uint mExcludedCombination1;
    uint mCursed;
    uint mMinGold;
    uint mMaxGold;
    uint mMultiplier;

    this() {

    }

    this(FreeabloIO.FAFile exe, uint codeOffset) {
        uint nameTemp = FreeabloIO.read32(exe);
        mEffect = FreeabloIO.read32(exe);
        mMinEffect = FreeabloIO.read32(exe);
        mMaxEffect = FreeabloIO.read32(exe);
        mQualLevel = FreeabloIO.read32(exe);

        mBowjewelProb = FreeabloIO.read8(exe);
        mWSProb = FreeabloIO.read8(exe);
        mASProb = FreeabloIO.read8(exe);
        mUnknown0 = FreeabloIO.read8(exe);

        mExcludedCombination0 = FreeabloIO.read32(exe);
        mExcludedCombination1 = FreeabloIO.read32(exe);

        mCursed = FreeabloIO.read32(exe);
        mMinGold  = FreeabloIO.read32(exe);
        mMaxGold = FreeabloIO.read32(exe);
        mMultiplier = FreeabloIO.read32(exe);
        mName = FreeabloIO.readCStringFromWin32Binary(exe, nameTemp, codeOffset);
    }

    string dump() {
        string result = "{" ~ newline
        ~ "\tmName: " ~ mName ~ newline
        ~ "\tmEffect: " ~ mEffect ~ ", " ~ newline
        ~ "\tmMinEffect: "  ~ mMinEffect ~ "," ~ newline
        ~ "\tmMaxEffect: "  ~ mMaxEffect ~ "," ~ newline
        ~ "\tmQualEffect: " ~ mQualLevel ~ "," ~ newline
        ~ "\tmBowjewelProb: " ~ mBowjewelProb ~ "," ~ newline
        ~ "\tmWSProb: " ~ mWSProb ~ "," ~ newline
        ~ "\tmASProb: " ~ mASProb ~ "," ~ newline
        ~ "\tmUnknown: " ~ mUnknown0 ~ "," ~ newline
        ~ "\tmExcludedCombination0: " ~ mExcludedCombination0 ~ "," ~ newline
        ~ "\tmExcludedCombination1: " ~ mExcludedCombination1 ~ "," ~ newline
        ~ "\tmCursed: " ~ mCursed ~ "," ~ newline
        ~ "\tmMinGold: " ~ mMinGold ~ "," ~ newline
        ~ "\tmMaxGold: " ~ mMaxGold ~ "," ~ newline
        ~ "\tmMultiplier: " ~ mMultiplier ~ "," ~ newline
        ~ "}" ~ newline;

        return result;
    }
}