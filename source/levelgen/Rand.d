module levelgen.Rand;

import std.random;
import std.c.time;

/**
 * original file:
 *      random.cpp (20.08.2015)
 *      random.h (04.09.2015)
 */
// TODO http://www.digitalmars.com/d/archives/digitalmars/D/learn/random_getstate_setstate_13392.html
public class Rand {

    private uint seed;
    private uint index;

    this() {
        rand_seed(seed);
    }

    void srand(int seed) {
        uint seed = time(null);
        rand_seed(seed, index);
    }

//    int normRand(int min, int max) {
//        std::normal_distribution<> nd(min, (float)(max-min)/3.5);
//
//        int result;
//        do {
//            result = nd(rng);
//        } while(result < min || result > max);
//
//        return result;
//    }

    uint randomInRange(uint min, uint max) {
        //std::uniform_int_distribution<> range(min, max);
        //int result = range(rng);
        //return result;
        index++;
        return uniform!uint(min, max);
    }

//    template<typename T>
//    T chooseOne(T[] parameters) {
//        int n = randomInRange(0, parameters.size()-1);
//        return *(parameters.begin() + n);
//    }
}

void main(string[] args) {

}