var roadmap = [
  {
    "completed": true,
    "day": 1,
    "quiz": [
      {
        "answer": "O(1)",
        "options": ["O(1)", "O(n)", "O(log n)", "O(n^2)"],
        "question":
            "What is the time complexity of accessing an element in an array using its index?"
      }
    ],
    "task":
        "Introduction to Data Structures and Algorithms: Learn about Big O notation, time and space complexity analysis, and basic array operations."
  },
  {
    "completed": true,
    "day": 2,
    "quiz": [
      {
        "answer": "Dynamic size allocation",
        "options": [
          "Faster access time",
          "Less memory usage",
          "Dynamic size allocation",
          "Easier implementation"
        ],
        "question":
            "What is the advantage of using a linked list over an array for insertions and deletions?"
      }
    ],
    "task":
        "Arrays and Linked Lists: Deep dive into array operations (insertions, deletions, searching) and various types of linked lists (singly, doubly, circular)."
  },
  {
    "completed": false,
    "day": 3,
    "quiz": [
      {
        "answer": "Stack",
        "options": ["Queue", "Stack", "Linked List", "Array"],
        "question":
            "Which data structure is used to implement function calls in a programming language?"
      }
    ],
    "task":
        "Stacks and Queues: Understand the concepts of LIFO and FIFO, implement stack and queue operations, and explore their applications."
  },
  {
    "completed": false,
    "day": 4,
    "quiz": [
      {
        "answer": "2 1 3",
        "options": ["1 2 3", "2 1 3", "2 3 1", "1 3 2"],
        "question":
            "What is the inorder traversal of a binary tree with root 1, left child 2, and right child 3?"
      }
    ],
    "task":
        "Trees: Introduction to tree data structures, binary trees, traversal algorithms (inorder, preorder, postorder), and basic tree operations."
  },
  {
    "completed": false,
    "day": 5,
    "quiz": [
      {
        "answer": "O(log n)",
        "options": ["O(1)", "O(n)", "O(log n)", "O(n^2)"],
        "question":
            "What is the worst-case time complexity for searching in a balanced BST?"
      }
    ],
    "task":
        "Binary Search Trees: Learn about BST properties, insertion, deletion, searching, and balancing techniques."
  },
  {
    "completed": false,
    "day": 6,
    "quiz": [
      {
        "answer": "Min-heap",
        "options": ["Min-heap", "Max-heap", "Binary heap", "Fibonacci heap"],
        "question": "Which type of heap is used to implement a priority queue?"
      }
    ],
    "task":
        "Heaps: Understand heap properties, implementation using arrays, heap sort algorithm, and priority queue implementation."
  },
  {
    "completed": false,
    "day": 7,
    "quiz": [
      {
        "answer": "Linear probing",
        "options": [
          "Linear probing",
          "Binary search",
          "Bubble sort",
          "Merge sort"
        ],
        "question": "What is a common method for resolving hash collisions?"
      }
    ],
    "task":
        "Hashing: Learn about hash functions, collision resolution techniques, and applications of hashing in data storage and retrieval."
  },
  {
    "completed": false,
    "day": 8,
    "quiz": [
      {
        "answer": "BFS",
        "options": ["BFS", "DFS", "A*", "Dijkstra's"],
        "question": "Which graph traversal algorithm uses a queue?"
      }
    ],
    "task":
        "Graphs: Introduction to graph representations (adjacency matrix, adjacency list), graph traversal algorithms (BFS, DFS), and basic graph operations."
  },
  {
    "completed": false,
    "day": 9,
    "quiz": [
      {
        "answer": "Merge sort",
        "options": [
          "Bubble sort",
          "Insertion sort",
          "Merge sort",
          "Selection sort"
        ],
        "question":
            "Which sorting algorithm has an average time complexity of O(n log n)?"
      }
    ],
    "task":
        "Sorting Algorithms: Study various sorting algorithms like bubble sort, insertion sort, selection sort, merge sort, and quick sort, and analyze their time and space complexities."
  },
  {
    "completed": false,
    "day": 10,
    "quiz": [
      {
        "answer": "Storing and reusing solutions to subproblems",
        "options": [
          "Divide and conquer",
          "Greedy approach",
          "Storing and reusing solutions to subproblems",
          "Backtracking"
        ],
        "question": "What is the key idea behind dynamic programming?"
      }
    ],
    "task":
        "Dynamic Programming: Introduction to dynamic programming principles, solving problems using memoization and tabulation techniques."
  },
  {
    "completed": false,
    "day": 11,
    "quiz": [
      {
        "answer": "BFS",
        "options": ["BFS", "DFS", "Binary Search", "Merge Sort"],
        "question":
            "Which graph traversal algorithm uses a queue data structure?"
      }
    ],
    "task":
        "**Graph Algorithms I:** Introduction to graphs, graph representations (adjacency matrix, adjacency list), graph traversal algorithms (BFS, DFS), applications of BFS and DFS."
  },
  {
    "completed": false,
    "day": 12,
    "quiz": [
      {
        "answer": "Bellman-Ford",
        "options": ["Dijkstra's", "Bellman-Ford", "BFS", "DFS"],
        "question":
            "Which shortest path algorithm can handle negative edge weights?"
      }
    ],
    "task":
        "**Graph Algorithms II:**  Shortest path algorithms (Dijkstra's algorithm, Bellman-Ford algorithm), detecting cycles in a graph."
  },
  {
    "completed": false,
    "day": 13,
    "quiz": [
      {
        "answer": "Prim's",
        "options": ["Dijkstra's", "Bellman-Ford", "Prim's", "BFS"],
        "question":
            "Which algorithm is used to find the Minimum Spanning Tree of a graph?"
      }
    ],
    "task":
        "**Graph Algorithms III:** Minimum Spanning Tree (MST) algorithms (Prim's, Kruskal's), topological sorting."
  },
  {
    "completed": false,
    "day": 14,
    "quiz": [
      {
        "answer": "Overlapping subproblems",
        "options": [
          "Recursion",
          "Iteration",
          "Overlapping subproblems",
          "Sorting"
        ],
        "question": "What is the core concept behind dynamic programming?"
      }
    ],
    "task":
        "**Dynamic Programming I:** Introduction to dynamic programming, overlapping subproblems, memoization, and tabulation."
  },
  {
    "completed": false,
    "day": 15,
    "quiz": [
      {
        "answer": "Knapsack problem",
        "options": [
          "Sorting an array",
          "Searching in a linked list",
          "Knapsack problem",
          "Reversing a string"
        ],
        "question":
            "Which of the following problems can be efficiently solved using Dynamic Programming?"
      }
    ],
    "task":
        "**Dynamic Programming II:** Solving classic DP problems like Fibonacci, longest common subsequence, and knapsack problem."
  },
  {
    "completed": false,
    "day": 16,
    "quiz": [
      {
        "answer": "Trie",
        "options": ["Binary Search Tree", "Trie", "Linked List", "Stack"],
        "question":
            "Which data structure is commonly used for implementing autocomplete functionality?"
      }
    ],
    "task":
        "**Advanced Data Structures I:** Trie (prefix tree), applications of Trie (autocomplete, spell checking)."
  },
  {
    "completed": false,
    "day": 17,
    "quiz": [
      {
        "answer": "Range queries",
        "options": [
          "Single element updates",
          "Range queries",
          "Sorting",
          "Searching"
        ],
        "question":
            "Segment trees are particularly useful for performing which type of operations?"
      }
    ],
    "task":
        "**Advanced Data Structures II:** Segment Tree, applications of segment tree (range queries)."
  },
  {
    "completed": false,
    "day": 18,
    "quiz": [
      {
        "answer": "Union-Find",
        "options": ["Union-Find", "Quick-Sort", "Merge-Sort", "Binary Search"],
        "question": "Disjoint Set Union is also known as:"
      }
    ],
    "task":
        "**Advanced Data Structures III:** Disjoint Set Union (DSU), applications of DSU (cycle detection in undirected graphs)."
  },
  {
    "completed": false,
    "day": 19,
    "quiz": [
      {
        "answer": "O(E log V)",
        "options": ["O(V+E)", "O(V^2)", "O(E log V)", "O(V log E)"],
        "question":
            "What is the time complexity of Dijkstra's algorithm using a min-heap?"
      }
    ],
    "task":
        "**Problem Solving I:** Practice problems on graph algorithms and dynamic programming."
  },
  {
    "completed": false,
    "day": 20,
    "quiz": [
      {
        "answer": "O(m)",
        "options": ["O(n)", "O(log n)", "O(m)", "O(1)"],
        "question":
            "What is the time complexity of a search operation in a Trie?"
      }
    ],
    "task":
        "**Problem Solving II:** Practice problems on advanced data structures."
  }
];
