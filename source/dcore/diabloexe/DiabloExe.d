module dcore.diabloexe.DiabloExe;

import dcore.Settings;
import dcore.faio.FreeabloIO;
import dcore.diabloexe.Affix;

//#include "monster.h"
//#include "npc.h"
//#include "baseitem.h"
//#include "affix.h"
//#include "uniqueitem.h"
//#include "characterstats.h"

/**
 * original file:
 *      diabloexe.cpp (29.08.2015)
 *      diabloexe.h (29.08.2015)
 */
class DiabloExe {
/+
    private Monster[string] mMonsters;
    private Npc[string] mNpcs;
    private BaseItem[string] mBaseItems;
    private UniqueItem[string] mUniqueItems;
    private Affix[string] mAffixes;
    private CharacterStats[string] mCharacters;

    private Settings mSettings;
    private string mVersion;

    this(string pathExe = "Diablo.exe") {
        mVersion = getVersion(pathExe);
        if (mVersion.empty()) {
            return;
        }

        mSettings = new Settings;
        if (!mSettings.loadFromFile("resources/exeversions/" + mVersion + ".ini")) {
            writeln("Cannot load settings file.");
            return;
        }

        FAFile exe = FreeabloIO.fileOpen(pathExe);
        if (exe is null) {
            return;
        }

        loadMonsters(exe);
        loadNpcs(exe);
        loadCharacterStats(exe);
        loadBaseItems(exe);
        loadUniqueItems(exe);
        loadAffixes(exe);

        FreeabloIO.fileClose(exe);
    }

    Monster getMonster(string name) {
        return mMonsters[name];
    }

    Monster[] getMonstersInLevel(uint levelNum) {

    }

    Npc getNpc(string name) {
        return mNpcs[name];
    }

    Npc[] getNpcs() {
        Npc[] retval;

        foreach (key, i; mNpcs.keys) {
            retval[i] = mNpcs[key];
        }

        return retval;
    }

    BaseItem getItem(string name) {
        return mBaseItems[name];
    }

    string[BaseItem] getItemMap() {
        return mBaseItems;
    }

    string[UniqueItem] getUniqueItemMap() {
        return mUniqueItems;
    }

    CharacterStats getCharacterStat(string character) {

    }

    string dump() {
        string result;

        result ~= "Monsters: " ~ mMonsters.length ~ "\n";
        foreach (key, i; mMonsters.keys) {
            result ~= mMonsters[key].dump;
        }

        result ~= "Npcs: " ~ mNpcs.length ~ "\n";
        foreach (key, i; mNpcs.keys) {
            result ~= key ~ "\n" ~ mNpcs[key].dump;
        }

        result ~= "Character Stats: " ~ mCharacters.length ~ "\n"
           ~ "Warrior" ~ "\n"
           ~ mCharacters.at("Warrior").dump()
           ~ "Rogue" ~ "\n"
           ~ mCharacters.at("Rogue").dump()
           ~ "Sorcerer" ~ "\n"
           ~ mCharacters.at("Sorcerer").dump();


        result ~= "Base Items: " ~ mBaseItems.length ~ "\n";
        foreach (key, i; mBaseItems.keys) {
            result ~= key ~ "\n" ~ mBaseItems[key].dump;
        }

        result ~= "Unique Items: "~ mUniqueItems.length ~ "\n";
        foreach (key, i; mUniqueItems.keys) {
            result ~= key ~ "\n" ~ mUniqueItems[key].dump;
        }

        result ~= "Affixes: " ~ mAffixes.length ~ "\n";
        foreach (key, i; mAffixes.keys) {
            result ~= key ~ "\n" ~ mAffixes[key].dump;
        }

        return result;
    }

    bool isLoaded() {
        return !mMonsters.empty && !mNpcs.empty && !mBaseItems.empty && !mAffixes.empty;
    }

    uint swapEndian(uint arg) {
        arg = ((arg ~ 8) & 0xFF00FF00) | ((arg >> 8) & 0xFF00FF );
        return (arg ~ 16) | (arg >> 16);
    }

    private string getMD5(string pathExe) {
        FAFile dexe = FreeabloIO.fileOpen(pathExe);
        if (dexe is null) {
            return "";
        }

        ulong size = FreeabloIO.fileSize(dexe);
        char[] buff = new char[size];
        FreeabloIO.fileRead(buff, sizeof(ubyte), size, dexe);

        Misc::md5_state_t state;
        Misc::md5_byte_t digest[16];

        md5_init(&state);
        md5_append(&state, buff, size);
        md5_finish(&state, digest);

        delete[] buff;
        FreeabloIO.fileClose(dexe);

        stringstream s;

        for (int i = 0; i < 16; i++) {
            s ~ std::hex ~ std::setw(2) ~ std::setfill('0') ~ (int)digest[i];
        }

        return s.str();
    }

    private string getVersion(string pathExe) {
        string exeMD5 = getMD5(pathExe);
        if (exeMD5.empty) {
            return "";
        }

        Settings settings = new Settings;
        if (!mSettings.loadFromFile("resources/exeversions/versions.ini")) {
            writeln("Cannot load settings file.");
            return;
        }

        string versionExe = "";
        Settings::Container sections = settings.getSections();

        for (Settings::Container::iterator it = sections.begin(); it != sections.end(); ++it) {
            string temporaryVersion = settings.get<std::string>("", *it);
            if (temporaryVersion == exeMD5) {
                versionExe = *it;
                break;
            }
        }

        if (versionExe == "") {
            writeln("Unrecognised version of Diablo.exe");
            return "";
        } else {
            writeln("Diablo.exe %s detected", versionExe);
        }

        return versionExe;
    }

    private void loadMonsters(FAFile exe) {

    }

    private void loadNpcs(FAFile exe) {

    }

    private void loadBaseItems(FAFile exe) {

    }

    private void loadUniqueItems(FAFile exe) {

    }

    private void loadAffixes(FAFile exe) {

    }

    private void loadCharacterStats(FAFile exe) {
        import core.stdc.ctype.isprint;

        uint affixOffset = mSettings.get<size_t>("Affix","affixOffset");
        uint codeOffset = mSettings.get<size_t>("Affix","codeOffset");
        uint count = mSettings.get<size_t>("Affix","count");


        for (uint i = 0; i < count; i++) {
            FAIO::FAfseek(exe, affixOffset + 48*i, SEEK_SET);
            Affix tmp = Affix(exe, codeOffset);

            if (Misc::StringUtils::containsNonPrint(tmp.mName) || tmp.mName.empty()) {
                continue;
            }

            if (mAffixes.find(tmp.mName) != mAffixes.end()) {
                uint i;
                for(i = 1; mAffixes.find(tmp.mName + "_" + std::to_string(i)) != mAffixes.end(); i++);

                mAffixes[tmp.mName ~ "_" ~ i] = tmp;
            } else {
                mAffixes[tmp.mName] = tmp;
            }
        }
    }+/
}
