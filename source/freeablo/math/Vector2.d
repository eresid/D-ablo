module math.Vector2;

struct Vector2 {
    float x = 0, y = 0;

    auto opNeg() {
        return Vector2(-x, -y);
    }

    auto opAdd(Vector2 a) {
        return Vector2(x + a.x, y + a.y);
    }

    auto opSub(Vector2 a) {
        return Vector2(x - a.x, y - a.y);
    }

    auto opMul(float n) {
        return Vector2(x*n, y*n);
    }

    auto opDiv(float n) {
        return Vector2(x/n, y/n);
    }

    float length() {
        return (x^^2 + y^^2)^^0.5;
    }

    float lengthsqr() {
        return x^^2 + y^^2;
    }

    auto normalized() {
        return this/length;
    }

    void normalize() {
        this = normalized;
    }

    void opOpAssign(string op, T) (T n) {
        this = mixin("this " ~ op ~ " n");
    }
}