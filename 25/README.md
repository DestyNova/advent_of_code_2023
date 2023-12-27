# Day 25: [Snowverload](https://adventofcode.com/2023/day/25)
*Picat: [Part 1](https://github.com/DestyNova/advent_of_code_2023/blob/main/25/part1.pi) (07:03:14, rank 5287), [Part 2](https://github.com/DestyNova/advent_of_code_2023/blob/main/25/part2.pi) (07:03:20, rank 4171)*

## Part 1

A fairly difficult problem for the last day: find the minimum edge-cut of a large graph. This went really badly for me -- I started by trying to formulate it as a SAT problem, taking advantage of the `scc` predicate in Picat. However, nothing I did seemed to work, even on the sample data.

My first attempts tried to constrain the results to have 3 missing edges, but after some thinking it became apparent that this wasn't right since a bunch of other edges would be missing from the graph after partitioning it into two subgraphs. After that realisation, I duplicated the graph and tried to constrain the problem such that the sum of connected edges in both graphs was equal to the total number of edges minus three (but actually six since I ended up with duplicate reverse edges), and the sum of vertices across both subgraphs would equal the vertex count in the original graph. But still no joy; just an instant `*** error(failed,main/0)`.

After a couple of hours of this, I switched to trying to implement [Karger's min-cut algorithm](https://www.scaler.com/topics/data-structures/kargers-algorithm-for-minimum-cut), a randomised algorithm that iteratively contracts edges until only two vertices are left. This quickly (well... ok, after a few minutes) got me down to 8 edges -- since this includes reverse edges we can treat this as equivalent to a 4-edge min-cut. The program is quite slow since I implemented it in a really inefficient way, continually searching lists of edges and inserting "supervertices" whose labels are a set of the original ones. Other people used the [union-find algorithm](https://cp-algorithms.com/data_structures/disjoint_set_union.html) to do this quickly, but by this point I was tired and wanted to do Christmas stuff, so decided to start afresh in Python and cheat by using the graph analysis library [networkx](https://networkx.org), which solved the problem in a few seconds and with only a few lines of code.

## Part 2

⭐

## Timings

Around 4 seconds.
