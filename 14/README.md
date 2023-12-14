# Day 14: [Parabolic Reflector Dish](https://adventofcode.com/2023/day/14)
*Picat: [Part 1](https://github.com/DestyNova/advent_of_code_2023/blob/main/14/part1.pi) (00:17:43, rank 2801), [Part 2](https://github.com/DestyNova/advent_of_code_2023/blob/main/14/part2.pi) (01:20:41, rank 3363)*

## Part 1

A classic AoC puzzle... at the beginning I had a feeling that part 2 might be "now do it a jillion times". Part 1 went okay, and Picat made it fairly easy for the most part.

## Part 2

And here we go with the "do it a jillion times". First I had to handle the other 3 movements. Rather than mess with the `move` logic which felt pretty error-prone, I decided to just rotate the entire grid using combinations of `transpose`, `reverse` and `map(reverse)`. This was inefficient but I suspected that efficiency wouldn't matter unless brute-forcing was a reasonable possibility. Apparently that was the case for a few people getting onto the leaderboard, but it wasn't going to work with Picat.

I'd seen a couple of problems like this before -- memorably a Tetris simulation where part two was something like "how high is the stack of blocks after 1000000000 moves?". After much puzzlement and analysis I discovered that the pattern of blocks repeated with a fixed set, plus some offset of blocks before the loop began.

The same turned out to be the case here, and it was easy to discover and characterise the loop, by putting each seen grid into a map along with the number of "spin cycles" it took to get to that state.

For example, the sample input was as follows:

```
Move: 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 ...
Grid: 1 2 3 4 5 6 7 8 9  3  4  5  6  7  8  9  3  4  5  6 ...
```

So after executing the 10th spin cycle, we reached a grid that we'd seen after the 3rd spin cycle, giving us a repeating loop of 7 states, entered after the first two moves. Those 7 states would then cycle forever as a closed loop. Since the loop has a fixed length of 7, then we can accelerate the loop by jumping ahead by any multiple of the loop size. For example, we could jump from cycle 10 to cycle 17, since they both end up on grid #3.

Since the cycle began at an offset of 3 iterations, then we can jump ahead to some iteration `3 + N * cycle_length`.
In the sample case we would jump to iteration 999999997 (3 + 142857142 * 7).

The logic for jumping to the correct iteration took me __far__ too long to get right. It felt like I was dealing with some sort of off-by-one error for 40 minutes or more. Basically we need to respect that starting offset, and also avoid overrunning the desired end step. The formula I ended up with was:

```
      I := Loop_begin + (N - Loop_begin) // Loop_size * Loop_size
```

The `(N - Loop_begin)` was needed to take into account that the beginning offset might be bigger than the loop size (and in fact was about 5 times larger).

All in all a good puzzle, even though I was slow to figure out the right numbers.

### Update 10:08

I heard from Hakan that solving it with tabling does work, and went back to check. Turns out I left out a `table` declaration in the most important place. The program was still quite slow though, taking about 5 minutes on the sample input. However, Picat's memory usage grew rapidly, up to about 25 Gb when I killed it at first. Adding a manual call to `garbage_collect/0` every 10,000 iterations or so seems to work, although it seems odd that Picat doesn't automatically do it on a more frequent basis.

Then it occurred to me that I could batch several calls together in the tabled function. In fact, since we want to do a total of 1000000000 steps, we can really perform any number of cycles that divides evenly into this number. There's obviously some tradeoff somewhere, but I found that an `Unroll_size` of 1000 solves the problem in 3.6 seconds. Wow. I'll have to remember that trick!

## Timings (with hyperfine)

### Part 1

```
Benchmark 1: picat part1.pi < input
  Time (mean ± σ):      17.7 ms ±   0.8 ms    [User: 8.6 ms, System: 9.0 ms]
  Range (min … max):    16.2 ms …  20.4 ms    131 runs
```

### Part 2

```
Benchmark 1: picat part2.pi < input
  Time (mean ± σ):      3.325 s ±  0.007 s    [User: 3.268 s, System: 0.055 s]
  Range (min … max):    3.319 s …  3.336 s    10 runs
```

### Part 2 with "unrolled DP"

```
Benchmark 1: picat part2_brute.pi < input
  Time (mean ± σ):      3.564 s ±  0.032 s    [User: 3.532 s, System: 0.025 s]
  Range (min … max):    3.538 s …  3.633 s    10 runs
```
