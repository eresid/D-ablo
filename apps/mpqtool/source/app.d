module fontgenerator;

import std.stdio;

import dcore.faio.FreeabloFileObject;

/**
 * original file:
 *      fontgenerator/main.cpp (04.06.2016)
 */
int main(string[] args) {
    if (args.length != 3) {
        writeln("The Freeablo MPQ tool accepts two parameters: ");
        writeln(argv[0], " <path to file in MPQ> <output file on file system>");
        writeln("The tool extracts the specified file within the Diablo MPQ file and extracts it to ");
        writeln("the output file as requested.");

        return 1;
    }

    // Open MPQ

    FreeabloIO faio = new FreeabloIO;
    if (!faio.init(args[1])) {
        writeln("Error: cannot init FAIO");
        return;
    }

    File output = File(argv[2], "w");

    int read = 1;
    uint8_t buffer[1024];

    while(read > 0) {
        read = file.FAfread(buffer, 1, sizeof(buffer));
        fwrite(buffer, 1, read, output);
    }

    output.close();

    faio.quit();
}
