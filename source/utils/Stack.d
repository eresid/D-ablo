module utils.Stack;

import std.array;

// http://rosettacode.org/wiki/Stack#D
public class Stack(T) {
    private T[] items;

    @property
    bool empty() {
        return items.empty();
    }

    void push(T top) {
        items ~= top;
    }

    T pop() {
        if (this.empty) {
            throw new Exception("Empty Stack.");
        }

        auto top = items.back;
        items.popBack();
        return top;
    }
}

unittest {
    auto stack = new Stack!int();
    stack.push(10);
    stack.push(20);
    assert(stack.pop() == 20);
    assert(stack.pop() == 10);
    assert(stack.empty());
}