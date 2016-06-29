module levelgen.Mst;

/**
 * original file:
 *      mst.cpp (03.02.2014)
 *      mst.h (03.02.2014)
 */
class Mst {

    // A utility function to find the vertex with minimum key value, from
    // the set of vertices not yet included in MST
    uint minKey(const uint[] key, const bool[] mstSet) {
        uint min = uint.max;
        uint minIndex = 0;

        foreach (v; key) {
            if (mstSet[v] == false && key[v] < min) {
                min = key[v];
                minIndex = v;
            }
        }

        return minIndex;
    }

    // Function to construct Minimum Spanning Tree for a graph, using Primms algorithm
    // (http://en.wikipedia.org/wiki/Prim%27s_algorithm).
    // Taken from http://www.geeksforgeeks.org/greedy-algorithms-set-5-prims-minimum-spanning-tree-mst-2/
    void minimumSpanningTree(immutable uint[][] graph, ref uint[] parent) {
        uint graphLength = graph[0].length;

        parent.length = graphLength;

        uint[] key = new uint[graphLength];
        bool[] mstSet = new bool[graphLength];

        // Initialize all keys as INFINITE
        // TODO maybe remove
        foreach (i; key) {
            key[i] = uint.max;
            mstSet[i] = false;
        }

        // Always include first 1st vertex in MST.
        key[0] = 0;     // Make key 0 so that this vertex is picked as first vertex
        parent[0] = -1; // First node is always root of MST

        foreach (count; 0 .. mstSet.length - 1) {
            uint u = minKey(key, mstSet);
            mstSet[u] = true;

            // Update key value and parent index of the adjacent vertices of
            // the picked vertex. Consider only those vertices which are not yet
            // included in MST
            foreach (v; key) {
                if (graph[u][v] && mstSet[v] == false && graph[u][v] < key[v]) {
                    parent[v]  = u;
                    key[v] = graph[u][v];
                }
            }
         }
    }
}
