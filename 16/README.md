# Day 16: [The Floor Will Be Lava](https://adventofcode.com/2023/day/16)
*Picat: [Part 1](https://github.com/DestyNova/advent_of_code_2023/blob/main/16/part1.pi) (00:35:38, rank 2030), [Part 2](https://github.com/DestyNova/advent_of_code_2023/blob/main/16/part2.pi) (00:42:51, rank 1812)*

## Part 1

Another grid puzzle! This time we had a cool light and mirrors problem, basically the ASCII art version of [Deflektor](https://www.c64-wiki.com/wiki/Deflektor) for the Commodore 64 which I played as a kid -- except the beam is restricted to 90 degree movement in the cardinal directions, rather than 30 degree increments as I seem to recall from that game.

Anyway, today's puzzle went quite well for me, although I made the classic error of trying to optimise too early by putting the beams into a set, then wasting time trying to figure out how to delete an item from a set or map in Picat. You can't. Seriously though, you can't.

After giving up on that and just using lists and `remove_dups`, I discovered that you could end up with an infinite loop depending on what paths certain rays took. This was easily fixed by adding another `Seen` set and ignoring beams (defined as a tuple `{X,Y,Direction}`) we've already processed.

## Part 2

I was surprised again today to find that part 2 was a trivial extension of part 1: instead of starting with the beam `{1,1,east}` -- that is, a beam heading to the right from the top left corner -- we run the simulation for all possible beam entrypoints. The grid is a 110x110 tile square, so we can just loop from 1..110 and run the simulation from `{1,I,east}`, `{110,I,west}`, `{I,1,south}` and `{I,110,north}`, taking the maximum of all returned scores.

The program isn't very efficient, and initially took around 17 seconds to finish. Then I tried removing the `Beams.remove_dups` call which I had added to make it go faster. Removing this dropped the time to around 3 seconds, proving that sometimes premature optimisation can make your program **slower**.

## Weird Picat error

I kept an intermediate version `part2_weird_error.pi` and corresponding .txt file which captured a really confusing error. It turned out I'd forgotten to pass in the `H` and `W` values, which were indeed treated as free variables. I really wish Picat would at least give line numbers, if not actually show the line in question with some visible markers.

## Timings (with hyperfine)

### Part 1

```
Benchmark 1: picat part1.pi < input
  Time (mean ± σ):      26.7 ms ±   1.0 ms    [User: 15.8 ms, System: 10.8 ms]
  Range (min … max):    24.6 ms …  30.2 ms    100 runs
```

### Part 2

```
Benchmark 1: picat part2.pi < input
  Time (mean ± σ):      2.722 s ±  0.047 s    [User: 2.676 s, System: 0.045 s]
  Range (min … max):    2.662 s …  2.792 s    10 runs
```
