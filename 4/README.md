# Day 4: [Scratchcards](https://adventofcode.com/2023/day/4)
*Picat: [Part 1](https://github.com/DestyNova/advent_of_code_2023/blob/main/4/part1.pi) (00:10:52, rank 3566), [Part 2](https://github.com/DestyNova/advent_of_code_2023/blob/main/4/part2.pi) (00:27:20, rank 3800)*

## Part 1

A very straightforward puzzle. I was slightly caught out by my code using floating point exponentiation and returning `0.5` when there were no matches (`2**(-1)`). Not sure if there's an integer power operator in Picat, but it was quickly solved using a `cond` expression.

## Part 2

This was one of those cases where the description text at first makes the problem seem more complicated than it is. I had to read it several times and thought at first that when card N wins a card M, you have to copy the current set of M's won cards over to N, and that you had to keep processing the whole deck until a steady state was reached.

But that of course made no sense and would never terminate. After a while I started just following the worked example and implementing enough code to replicate that behaviour... which turned out to produce the correct output.

I used a map to store the counts for each card (yes, an array would make more sense but it doesn't matter), and transformed `extract` into a side-effecting predicate that just updates counts in the map.

Moral of the story: I dunno; if there's a detailed example, maybe jump straight to that and use that to build an understanding of the problem, rather than letting the abstract description text throw you off.

## Timings (with hyperfine)

### Part 1

```
Benchmark 1: picat ./part1.pi < input
  Time (mean ± σ):      29.1 ms ±   0.9 ms    [User: 18.1 ms, System: 10.9 ms]
  Range (min … max):    27.4 ms …  31.9 ms    95 runs
```

### Part 2

```
Benchmark 1: picat ./part2.pi < input
  Time (mean ± σ):      29.6 ms ±   0.8 ms    [User: 18.1 ms, System: 11.7 ms]
  Range (min … max):    28.2 ms …  32.4 ms    88 runs
```
