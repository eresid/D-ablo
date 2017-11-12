module dcore.faio.FreeabloIO;

import std.stdio;
import std.file;

/**
 * The functions in this header are designed to behave roughly like the normal fopen, fread family.
 * The difference is, if FAfopen is called on a file that doesn't exist, it will try to use StormLib
 * to open it in the MPQ file DIABDAT.MPQ.
 *
 * original file:
 *      faio.cpp (26.03.2016)
 *      faio.h (26.03.2016)
 */
class FreeabloIO {

    private immutable string DIABDAT_MPQ = "DIABDAT.MPQ";

    private HANDLE diabdat = null;

    enum FAFileMode {
        PlainFile,
        MPQFile
    }

    union FAFileUnion {
        File file;
        string filename;
        HANDLE mpqFile; // This is a StormLib HANDLE type
    }

    // A FILE* like container for either a normal FILE*, or a StormLib HANDLE
    struct FAFile {
        FAFileUnion data;
        FAFileMode mode;
    }

    // StormLib needs paths with windows style \'s
    string getStormLibPath(string path) {
        return path.replace("/", "\\");
    }

    bool init(string pathMPQ) {
        pathMPQ = pathMPQ is null ? DIABDAT_MPQ : pathMPQ;

        bool success = SFileOpenArchive(pathMPQ, 0, STREAM_FLAG_READ_ONLY, &diabdat);

        if (!success) {
            writeln("Failed to open %s with error %s", pathMPQ, GetLastError());
        }

        return success;
    }

    void quit() {
        if (diabdat != null) {
            SFileCloseArchive(diabdat);
        }
    }

    synchronized bool exists(string filename) {
        if (exists(filename)) {
            return true;
        }

        string stormPath = getStormLibPath(path);
        return SFileHasFile(diabdat, stormPath);
    }

    static FAFile fileOpen(string filename) {
        if (!exists(filename)) {
            synchronized (m) {
                string stormPath = getStormLibPath(path);

                if (!SFileHasFile(diabdat, stormPath)) {
                    writeln("File " ~ path ~ " not found");
                    return null;
                }

                FAFile file = new FAFile();
                file.data.mpqFile = malloc(sizeof(HANDLE));

                if (!SFileOpenFileEx(diabdat, stormPath, 0, file.data.mpqFile)) {
                    writeln("Failed to open %s in %s", filename, DIABDAT_MPQ);
                    delete file;
                    return null;
                }

                file.mode = FAFileMode.MPQFile;

                return file;
            }
        } else {
            File plainFile = new File(filename, "r");
            if (!exist(plainFile)) {
                return null;
            }

            FAFile file = new FAFile();
            file.mode = FAFileMode.PlainFile;
            file.data.file = plainFile;
            file.data.filename = filename;

            return file;
        }
    }

    synchronized ulong fileRead(char[] ptr, ulong size, ulong count, FAFile stream) {
        switch(stream.mode) {
            case FAFileMode.PlainFile:
                return fread(ptr, size, count, stream.data.file);

            case FAFileMode.MPQFile: {
                DWORD dwBytes = 1;
                if (!SFileReadFile(*stream.data.mpqFile, ptr, size * count, &dwBytes, null)) {
                    int errorCode = GetLastError();

                    // if the error code is ERROR_HANDLE_EOF, it's not really an error,
                    // we just requested a read that goes over the end of the file.
                    // The normal fread behaviour in this case is to truncate the read to fit within
                    // the file, and return the actual number of bytes read, which we do,
                    // so there is no need to print an error message.
                    if (errorCode != ERROR_HANDLE_EOF) {
                        writeln("Error reading from file, error code: %s", errorCode);
                    }
                }

                return dwBytes;
            }
        }

        return 0;
    }

    static synchronized int fileClose(FAFile stream) {
        int retval = 0;

        switch(stream.mode) {
            case FAFileMode.PlainFile: {
                delete stream.data.filename;
                retval = fclose(stream.data.file);
                break;
            }

            case FAFileMode.MPQFile: {
                int res = SFileCloseFile(*stream.data.mpqFile);
                free(stream.data.mpqFile);

                if (res != 0) {
                    retval = EOF;
                }

                break;
            }
        }

        destroy(stream);

        return retval;
    }

    int FAfseek (FAFile stream, ulong offset, int origin) {

    }

    synchronized ulong FAftell(FAFile stream) {
        switch(stream.mode) {
            case FAFileMode.PlainFile:
                return ftell(stream.data.file);

            case FAFileMode.MPQFile: {
                return SFileSetFilePointer(*stream.data.mpqFile, 0, null, FILE_CURRENT);
            }

            default:
                return 0;
        }
    }

    static synchronized ulong fileSize(FAFile stream) {
        switch(stream.mode) {
            case FAFileMode.PlainFile: {
                return getSize(stream.data.filename);
            }

            case FAFileMode.MPQFile: {
                return SFileGetFileSize(stream.data.mpqFile, null);
            }

            default:
                return 0;
        }
    }

    static int read32(ref FAFile file) {
        int tmp;
        fileRead(tmp, 4, 1, file);
        return tmp;
    }

    static short read16(ref FAFile file) {
        short tmp;
        fileRead(tmp, 2, 1, file);
        return tmp;
    }

    static byte read8(ref FAFile file) {
        byte tmp;
        fileRead(tmp, 1, 1, file);
        return tmp;
    }

    string readCString(FAFile file, ulong ptr) {
        string retval = "";

        if (ptr) {
            FAfseek(file, ptr, SEEK_SET);
            char c = 0;

            ulong bytesRead = fileRead(c, 1, 1, file);

            while(c != '\0' && bytesRead) {
                retval += c;
                bytesRead = fileRead(c, 1, 1, file);
            }
        }

        return retval;
    }

	static string readCStringFromWin32Binary(FAFile file, ulong ptr, ulong offset) {
	    if (ptr) {
	        return readCString(file, ptr - offset);
	    }

        return "";
	}

//    string getMPQFileName() {
//        File file = new File(".");
//        bfs::directory_iterator end;
//        for (bfs::directory_iterator entry(".") ; entry != end; entry++) {
//            if (!bfs::is_directory(*entry)) {
//                if (boost::iequals(entry->path().leaf().generic_string(), DIABDAT_MPQ)) {
//                    return entry->path().leaf().generic_string();
//                }
//            }
//        }
//
//        writeln("Failed to find %s in current directory", DIABDAT_MPQ);
//
//        return "";
//    }
}

unittest {
    string path = "/home/user/Document/file.txt";
    assert(getStormLibPath(path), "\\home\\user\\Document\\file.txt");
}