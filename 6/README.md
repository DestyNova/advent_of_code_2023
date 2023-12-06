# Day 6: [Wait For It](https://adventofcode.com/2023/day/6)
*Picat: [Part 1](https://github.com/DestyNova/advent_of_code_2023/blob/main/6/part1.pi) (00:27:36, rank 8611), [Part 2](https://github.com/DestyNova/advent_of_code_2023/blob/main/6/part2.pi) (00:33:34, rank 7926)*

## Part 1

The easiest puzzle so far. After wasting time on parsing as usual, I somehow overcomplicated the code by counting "distance so far" even though that should of course be zero. Hey, it was 5 am!

## Part 2

My first instinct was that it would be one of those puzzles where part 1 can be easily brute forced, but part 2's massive numbers require a total redesign to use actual maths to calculate the solution in one step. But nope, brute force all the way.

I discovered a curious oddity where inlining one calculation (instead of assigning it to a variable, even though it's only referenced once) slows down the program by 50%. I've marked the appropriate line if you want to try it. It might be that assigning it to a variable (ok fine, [unifying it](https://www.dai.ed.ac.uk/groups/ssp/bookpages/quickprolog/node12.html) with a variable causes its type information to be cached for the remainder of the program, rather than recalculated every time through the loop... maybe?

## Timings (with hyperfine)

### Part 1

```
Benchmark 1: picat part1.pi < input
  Time (mean ± σ):      19.2 ms ±   0.7 ms    [User: 7.1 ms, System: 12.0 ms]
  Range (min … max):    17.7 ms …  21.4 ms    129 runs
```

### Part 2

```
Benchmark 1: picat part2.pi < input
  Time (mean ± σ):      1.350 s ±  0.015 s    [User: 1.341 s, System: 0.007 s]
  Range (min … max):    1.338 s …  1.379 s    10 runs
```
