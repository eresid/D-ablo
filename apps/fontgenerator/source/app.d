module fontgenerator;

import std.stdio;

import components.FreeabloIO;
import components.cel.CelDecoder;
import components.cel.CelFrame;

/**
 * original file:
 *      fontgenerator/main.cpp (04.06.2016)
 */
int main(string[] args) {
    if (args.length < 2) {
        writeln("%s mpq_path", args[0]);
        writeln("Application generates part of libRocket font file.");

        return 0;
    }

    // Open MPQ

    HANDLE handle;
    SFileOpenArchive(args[1], 0, STREAM_FLAG_READ_ONLY, &handle);

    FreeabloIO faio = new FreeabloIO;
    if (!faio.init(args[1])) {
        writeln("Error: cannot init FAIO");
        return;
    }

    // For now only smaltext.cel

    CelDecoder cel = new CelDecoder("ctrlpan/smaltext.cel");

    // Prepare ascii vector according to order in cel file
    int[] ascii;

    for (int i = 'a' ; i <= 'z' ; i++) {
        ascii[ascii.length] = i;
    }

    for (int i = '1' ; i <= '9'; i++) {
        ascii[ascii.length] = i;
    }

    ascii[ascii.length] = '0';

    // I can't find mapping in ascii table for one signs so
    // I marked it as 255
    int[] asciiSigns = { '-', '=', '+', '(', ')', '[', ']', '"', 255, '`',
                         '\'',':',';',',','.','/','?','!','&','%',
                         '#','$','*','<','>','@','\\','^','_','|','~'};

    ascii ~= asciiSigns;

    int[string] mapping;

    int positionX = 0;

    for (uint i = 0 ; i < cel.numFrames(); i++) {
        CelFrame frame = cel[i];
        uint maximumVisibleX = 0;
        for (uint x = 0; x < frame.mWidth; x++) {
            for (uint y = 0; y < frame.mHeight; y++) {
                if (frame[x][y].visible) {
                    if (x > maximumVisibleX) {
                        maximumVisibleX = x;
                    }
                }
            }
        }

        int asciiIdx = ascii[i];

        // Additional 2 pixels for every letter
        maximumVisibleX += 2;
        if (maximumVisibleX > frame.mWidth) {
            maximumVisibleX = frame.mWidth;
        }

        // Create output
        string output = "<char id=\"" ~ asciiIdx ~ "\" x=\"" ~ positionX ~ "\" y=\"0\" width=\"" ~ maximumVisibleX ~
                    "\" height=\"11\" xoffset=\"0\" yoffset=\"0\" xadvance=\"" ~ maximumVisibleX ~ "\" />";
        mapping[asciiIdx] = output;

        // Move further
        positionX += 13;
    }

    // Sort by ascii
    ascii.sort;

    foreach (int i; ascii) {
        writeln(mapping[i]);
    }

    faio.quit();
}
