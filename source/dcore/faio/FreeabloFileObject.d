module dcore.faio.FreeabloFileObject;

import std.stdio;

import components.faio.FreeabloIO;

// wrapper api for faio
class FAFileObject {

    private FAFile faFile;
    private FreeabloIO faio;

    this(const string pathFile) {
        faFile = FAfopen(pathFile);
        faio = new FreeabloIO;
    }

    bool isValid() {
        return faFile != null;
    }

    bool exists(const string filename) {
        return faio.exists(filename);
    }

    size_t FAfread(void * ptr, size_t size, size_t count) {
        if (!faFile) {
            writeln("FAFileWrapper::FAfread: faFile is NULL.");
            return 0;
        }
        return faio.FAfread(ptr, size, count, faFile);
    }

    int FAfseek(size_t offset, int origin) {
        if (!faFile) {
            writeln("FAFileWrapper::FAfseek: faFile is NULL.");
            return 0;
        }
        return faio.FAfseek(faFile, offset, origin);
    }

    size_t FAftell() {
        if (!faFile) {
            writeln("FAFileWrapper::FAftell: faFile is NULL.");
            return 0;
        }
        return faio.FAftell(faFile);
    }

    size_t FAsize() {
        if (!faFile) {
            writeln("FAFileWrapper::FAsize: faFile is NULL.");
            return 0;
        }
        return faio.FAsize(faFile);
    }

    uint read32() {
        if (!faFile) {
            writeln("FAFileWrapper::read32: faFile is NULL.");
            return 0;
        }
        return faio.read32(faFile);
    }

    ushort read16() {
        if (!faFile) {
            writeln("FAFileWrapper::read16: faFile is NULL.");
            return 0;
        }
        return faio.read16(faFile);
    }

    ubyte read8() {
        if (!faFile) {
            writeln("FAFileWrapper::read8: faFile is NULL.");
            return 0;
        }
        return faio.read8(faFile);
    }

    string readCString(size_t ptr) {
        if (!faFile) {
            writeln("FAFileWrapper::read8: faFile is NULL.");
            return "";
        }
        return faio.readCString(faFile, ptr);
    }

    string readCStringFromWin32Binary(size_t ptr, size_t offset) {
        if (!faFile) {
            writeln("FAFileWrapper::readCStringFromWin32Binary: faFile is NULL.");
            return "";
        }
        return faio.readCStringFromWin32Binary(faFile, ptr, offset);
    }


    static string getMPQFileName() {
        return faio.getMPQFileName();
    }

    static void quit() {
        faio.quit();
    }
}