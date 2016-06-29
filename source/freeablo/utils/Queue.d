module utils.Queue;

// http://rosettacode.org/wiki/Queue/Usage#D
class Queue(T) {

    private static struct Node {
        T data;
        Node* next;
    }

    private Node* head, tail;

    bool empty() { return head is null; }

    void push(T item) {
        if (empty()) {
            head = tail = new Node(item);
        } else {
            tail.next = new Node(item);
            tail = tail.next;
        }
    }

    T pop() {
        if (empty()) {
            throw new Exception("Empty LinkedQueue.");
        }

        auto item = head.data;
        head = head.next;

        // Is last one?
        if (head is tail) {
            // Release tail reference so that GC can collect.
            tail = null;
        }

        return item;
    }

    alias push enqueue;
    alias pop dequeue;
}

unittest {
    auto queue = new Queue!int();
    queue.push(10);
    queue.push(20);
    queue.push(30);
    assert(queue.pop() == 10);
    assert(queue.pop() == 20);
    assert(queue.pop() == 30);
    assert(queue.empty());
}