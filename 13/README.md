# Day 13: [Point of Incidence](https://adventofcode.com/2023/day/13)
*Picat: [Part 1](https://github.com/DestyNova/advent_of_code_2023/blob/main/13/part1.pi) (00:49:46, rank 3921), [Part 2](https://github.com/DestyNova/advent_of_code_2023/blob/main/13/part2.pi) (01:18:21, rank 3615)*

## Part 1

This was a really fun problem. Despite being badly sleep-deprived at this point, I felt like this went ok.

## Part 2

The solution I came up with was a bit inefficient and ugly...

For each axis of each grid:

1. Run the part 1 solution and get the result R.
2. Now, for every tile on the grid...
    1. Flip it (using mutation to update the grid in-place, thanks Picat)
    2. Check for a solution again that isn't equal to R
    3. Unflip the tile
3. Only count the axes which returned multiple solutions, and take the last one (i.e. not R).

This worked, but took about 600 ms for my input file.

After completing the puzzle I watched [Jonathan Paulson's solving video](https://www.youtube.com/watch?v=KObhCimyl2I) and really liked his much more efficient method, which is more like my part 1, but counts the number of mismatched pairs of tiles when testing each row / column for symmetry. For part 1, a count of zero is needed, and in part 2 a count of exactly one is required.

I implemented this in Picat, which allowed me to cut out a lot of code and get the runtime down from 600 ms to 56 ms. Not bad.

## Timings (with hyperfine)

### Part 1

```
Benchmark 1: picat part1.pi < input
  Time (mean ± σ):      18.3 ms ±   0.7 ms    [User: 8.0 ms, System: 10.3 ms]
  Range (min … max):    16.8 ms …  21.4 ms    133 runs
```

### Part 2

```
Benchmark 1: picat part2.pi < input
  Time (mean ± σ):     605.0 ms ±   3.2 ms    [User: 425.2 ms, System: 179.4 ms]
  Range (min … max):   600.6 ms … 610.9 ms    10 runs
```

### Part 2 with the "error counting" strategy

```
Benchmark 1: picat part2_count_diffs.pi < input
  Time (mean ± σ):      55.9 ms ±   1.0 ms    [User: 36.7 ms, System: 19.1 ms]
  Range (min … max):    54.4 ms …  61.2 ms    49 runs
```
