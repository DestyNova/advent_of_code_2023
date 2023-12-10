# Day 10: [Pipe Maze](https://adventofcode.com/2023/day/10)
*Picat: [Part 1](https://github.com/DestyNova/advent_of_code_2023/blob/main/10/part1.pi) (01:42:10, rank 6923), [Part 2](https://github.com/DestyNova/advent_of_code_2023/blob/main/10/part2.pi) (03:15:08, rank 4443)*

## Part 1

I'm not sure why implementing a BFS in Picat took me so long after doing it in several languages many times in previous AoC puzzles. But anyway... I started trying to use Picat in a more "Prologgy" way but kept getting stuck, and eventually went a more imperative route.

## Part 2

Now this was quite a tough twist -- find all the points fully enclosed within the loop. The sensible method here is to apply the basic ray-casting algorithm for testing whether a point lies within a polygon. For each point in the grid. But we can't include points on the actually perimeter (the pipe path), and we also can't count "grazing" or skimming of the path if it doesn't actually cross into or out of the loop interior.
This last point is what took me over an hour to wrap my head around, finally coming up with a couple of rules for crossing into / out of the loop interior:

```picat
is_crossing('L', '7').
is_crossing('F', 'J').
is_grazing('L', 'J').
is_grazing('F', '7').
```

So if we reach an `L` for example, we've found an edge and will cross into a new region if we subsequently encounter a "7" OR consider it a "graze" if we encounter a `J`. This means that the `o` marked locations of the following grid row will not be considered to have crossed a region when casting a ray from x=0:

```
.L--JoL--Jo
```

Seems simple now, but while debugging and looking at the (thankfully plentiful) example grids, it didn't feel so simple!

This method is relatively inefficient but the program still runs in 0.2s. The repeated ray casting seems wasteful because it repeatedly traverses segments that have already been scanned, so it's possible that we could keep track of the latest state rather than recalculating it for every column. My first attempt failed though, producing duplicate counts, so I'll leave that for another day (or, more likely, never).

## Timings (with hyperfine)

### Part 1

```
Benchmark 1: picat part1.pi < input
  Time (mean ± σ):      74.5 ms ±   1.0 ms    [User: 59.7 ms, System: 14.8 ms]
  Range (min … max):    72.9 ms …  77.4 ms    38 runs
```

### Part 2

```
Benchmark 1: picat part2.pi < input
  Time (mean ± σ):     205.8 ms ±   4.8 ms    [User: 186.3 ms, System: 19.3 ms]
  Range (min … max):   201.3 ms … 221.3 ms    14 runs
```
