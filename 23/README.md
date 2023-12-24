# Day 23: [A Long Walk](https://adventofcode.com/2023/day/23)
*Picat: [Part 1](https://github.com/DestyNova/advent_of_code_2023/blob/main/23/part1.pi) (01:01:42, rank 1540), [Part 2](https://github.com/DestyNova/advent_of_code_2023/blob/main/23/part2.pi) (01:34:36, rank 464)*

Advent of Code is doubling down on grids this year it seems! Another 2D pathfinding puzzle (can we get a 3D one next year?!), this time with two interesting variations:

1. One-way slopes (part 1 only)
2. We need to find the __longest__ path, not the shortest one!
3. ...Without entering the same tile more than once.

You might at first think "pfft, just reverse the sign when calculating path costs with the usual methods (BFS / Dijkstra)". But no, this leads to suboptimal paths because those algorithms terminate as soon as the goal state is reached.

## Part 1

Some people apparently came up with clever variations of Dijkstra to get it working, but I thought it would be a good time to try Picat's `planner` module again. I'd had success with it in the past although it wasn't super fast. It does however allow you to find optimal plans with very simple and concise code, without having to define exactly how the search should be performed.

However! The docs for `best_plan` and related predicates all talk about trying to minimise costs, initially attempting to find a solution with `Cost = 0`. This seemed to rule out the possibility of specifying negative costs on each step, but to my surprise the `best_plan_unbounded` predicate found the correct solution for part 1 after around 80 seconds.

## Part 2

Part 2 was conceptually much simpler: ignore the one-way slopes. So, just delete a few lines from the part 1 program and we're done? Nope! It turns out that the slopes in part 1 heavily constrained the search space in what is otherwise a much harder problem than searching for the shortest path.

Unfortunately my `planner` program for part 1 just couldn't do it for part 2, and rapidly used all available memory, eventually taking over 30 GB of RAM and 20 or so of swap space. Of course, as soon as a program like this starts using swap space, the rate of progress drops to basically zero.

I decided to try DFS instead, and managed to get it working on the sample input. Someone gave me a hint that I didn't need to keep duplicating the "seen" set of states (required to avoid infinite loops), since DFS is a straight recursive stack-type operation: you can just mark a cell as seen, recurse into DFS at that tile, then unmark the cell and move onto the next. This is in contrast to BFS, where you're pulling work from a queue to decide what to evaluate next, and you can't know ahead of time the order in which you'll look at things.

Anyway, DFS was working for the sample input, but even with that hint which allowed me to get through it much faster, it was still using a couple of gigs of RAM and moving quite slowly. While waiting for that, I took an old Nim DFS implementation and rewrote it for this problem, and it produced the correct answer for part 2 after 6 minutes (going many, many times faster than the Picat version).

The Nim version evaluated over 11330000000 states to arrive at the eventual answer. This is awful, so maybe there is a more efficient way than DFS which is the absolute dumbest of search algorithms, although its younger brother IDS isn't so bad, if a solution can be found at a reasonable depth.

In this case the longest path was 6302 steps, which is ordinarily beyond what you'd expect DFS could find. However, this problem is a bit special, as is often the case in Advent of Code puzzles: the grid isn't just a random maze, but one full of long corridors where you can only continue straight ahead. There are only a small number of junctions in the grid. Later on I watched [Hyperneutrino's solution video](https://www.youtube.com/watch?v=NTLYL7Mg2jU) which mentioned edge contraction as a way to reduce the graph and make it more easily solvable. The idea is that the extended "straight ahead" segments of N 1-cost steps can be compressed into a single edge of weight N between the starting and ending vertices.

More info on that here:

* https://mathworld.wolfram.com/EdgeContraction.html
* https://mathworld.wolfram.com/GraphMinor.html -- apparently repeated edge contractions reduce the graph to a "graph minor", but getting there seems to be an NP-hard problem. Perhaps the flood-fill method used in Hyperneutrino's video gets a good enough result though.

With that said, I'm not quite sure why edge contraction would actually make the DFS faster, since the long passageways with no choice don't really slow DFS down (it just immediately marks each node visited and recurses to the next node). I think it might be more relevant to BFS. But it'll probably reduce memory usage somewhat?

## Memory and GC in Picat

The `planner` version of part 2 in Picat was chewing through memory like a black hole, which was fair enough since there were so many states to keep track of. In part 1 the same thing happened at first, but (sort of ironically) adding a `table` directive reduced the memory usage -- effectively using a cache to somehow save **memory** (wat?!).

But I was surprised to find even my straight DFS version was also horsing through memory. It became apparent that Picat's garbage collector is a bit lazy and seems to only kick in when memory pressure reaches some "emergency" threshold. However I consider "your SSD drive is now being used for swap" to be well beyond that threshold since even on a fast drive, swap is going to reduce your performance to a crawl compared to RAM access (and even that is slow compared to pulling lines from the L1/2/3 cache).
That's probably one of the biggest advantages of writing stuff in C or other low-level languages -- it produces a small code and data structures come with less tagging (e.g. reference counts or GC markers etc), so more of the "tight" parts of your program will fit into super-fast cache memory. The benefits are so pronounced that it's often feasible for people to brute-force some of the puzzles where it would seem hopeless, but they're using fairly low-overhead languages like C, C++, D, Pascal, Rust and Jai.

Getting back to memory and GC in Picat: the DFS version was using way too much memory. Eventually I added a counter and manually triggered the garbage collector once in every 80,000 calls to `dfs`:

```picat
  if Max mod 400 == 0 then
    println(Max),
    Gc = get_global_map(g1).get(gc),
    if Gc mod 200 == 0 then
      println(gc),
      garbage_collect()
    end,
    get_global_map(g1).put(gc, Gc+1),
  end,
```

## SAT solver version

The promise of SAT solving as a general method for declarative problem solving was too great to ignore here, so I tried out the `path_d` predicate in Picat's `sat` solver module. It was surprisingly easy to specify the constraints (enter each tile only once) once I'd transformed the grid to two lists:

1. a vertex list `Vs` of `{{I,J},In_graph}` with the latter value left blank, to be replaced with boolean domain variables signifying membership in the graph, and
2. an edge list `Es` of `{From_vertex, To_vertex, Is_in_path}`, with the latter value left blank to be replaced by a boolean domain variable signifying that the edge is part of the final path.

I'm not actually sure how you would represent a path that crosses the same cell twice, but that's a problem for the other day.

This works really well on the sample grid, but the full grid just seems too big: at 141x141 cells, my graph contained 9,398 vertices and 18,844 valid edges. The program takes about a minute just to prepare all the constraints before it even starts the SAT solver. I left it running earlier while out shopping for about 90 minutes, and it was nowhere near the solution yet (although the rate of progress seems to be random from run to run). Of course, when you specify the mechanics of exactly how the problem should be solved, you can often take better advantage of the special structure of the problem -- for example, using techniques like edge contraction to reduce the graph to a sparser but equivalent weighted graph. The SAT solver probably has some heuristics for doing things like this, but may not be able to prove in all cases that it's safe to do so -- much like compiler optimisations which are similarly limited in the assumptions they can make.

I then forgot about it and left it running for almost 7 more hours on the full input and it didn't terminate. So it seems for this kind of problem SAT might be unsuitable; or there's some strategy I'm missing that would enable it to make shortcuts.

## Timings (with hyperfine)

Nah, both parts are slow.
