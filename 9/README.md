# Day 9: [Mirage Maintenance](https://adventofcode.com/2023/day/9)
*Picat: [Part 1](https://github.com/DestyNova/advent_of_code_2023/blob/main/9/part1.pi) (00:18:20, rank 3507), [Part 2](https://github.com/DestyNova/advent_of_code_2023/blob/main/9/part2.pi) (00:20:51, rank 2761)*

## Part 1

This looked a bit like [Pascal's Triangle](https://mathworld.wolfram.com/PascalsTriangle.html) to me, but I couldn't figure out a way to cleanly extrapolate the next number in one step. After a while I gave up and just did what the problem description said. No problems.

## Part 2

After reading the part 2 problem description, it immediately occurred to me that it might be possible to achieve by simply reversing the numbers in each input row. This seemed too simple to possibly work, but... it did. Huh?

```
❯ diff part1.pi part2.pi 
9c9
<   Ns = S.split().map(parse_term),
---
>   Ns = S.split().map(parse_term).reverse(),
```

## Timings (with hyperfine)

### Part 1

```
Benchmark 1: picat part1.pi < input
  Time (mean ± σ):      31.9 ms ±   0.7 ms    [User: 21.0 ms, System: 10.8 ms]
  Range (min … max):    30.5 ms …  33.6 ms    84 runs
```

### Part 2

```
Benchmark 1: picat part2.pi < input
  Time (mean ± σ):      31.9 ms ±   0.7 ms    [User: 21.3 ms, System: 10.6 ms]
  Range (min … max):    30.7 ms …  34.6 ms    78 runs
```
