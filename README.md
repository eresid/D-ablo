### FreeabloD
Modern reimplementation of the Diablo 1 game engine. Clone [Freeablo](https://github.com/wheybags/freeablo) on D language.

### Other implementations

- [DGEngine](https://github.com/dgengin/DGEngine)
- [Devilution](https://github.com/galaxyhaxz/devilution)

##### Status
Broken pre-alpha

##### Dependencies
- SDL2
- SDL2Mixer
- SDL2Image
- DUB

Without boost, python, cmake, libRocket, without Qt5, libbz2 and zlib

##### Rewrited (need test and review):
- Main.d (main.cpp)
- Settings.d (settings.cpp, settings.h)
- Position.d (position.cpp, position.h)
- Misc.d (misc.cpp, misc.h)
- Md5.d (md5.cpp/md5.h)
- Mst.d (rewrite mst.cpp/mst.h)

##### In progress:
- FreeabloIO.d (faio.cpp, faio.h)
- LevelObjects.d (levelobjects.cpp, levelobjects.h)
- EngineMain.d (enginemain.cpp, enginemain.h)
- InputObserverInterface.d (inputobserverinterface.h)
- ThreadManager.d (threadmanager.cpp, threadmanager.h)

#### ShtormLib
To compile [StormLib](https://github.com/ladislav-zezula/StormLib) for Linux:
```
make -f Makefile.linux
```

##### Details
- http://www.diablo1.ru/game/
- https://www.youtube.com/watch?v=FgB5sjDPEV4

##### License
Original code under GPLv3, my code under MIT, you can use my code in commercial projects without my claims, but better discuss this with Freeablo authors
