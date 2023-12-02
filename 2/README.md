# Day 2: [Cube Conundrum](https://adventofcode.com/2023/day/2)
*Picat: [Part 1](https://github.com/DestyNova/advent_of_code_2023/blob/main/2/part1.pi) (00:27:48, rank 6382), [Part 2](https://github.com/DestyNova/advent_of_code_2023/blob/main/2/part2.pi) (00:32:13, rank 5662)*

## Part 1

Another very simple problem. I got stuck on some basic Picat issues, but logically there wasn't much to this one. As usual, parsing was a bit awkward. Like I mentioned yesterday, it's time to learn DCGs, which probably would have helped.

## Part 2

Part 2 was trivial once part 1 was implemented.

## Timings (with hyperfine)

### Part 1

```
Benchmark 1: picat ./part1.pi < input
  Time (mean ± σ):      18.7 ms ±   0.7 ms    [User: 9.8 ms, System: 8.8 ms]
  Range (min … max):    17.2 ms …  20.5 ms    134 runs
```

### Part 2

```
Benchmark 1: picat ./part2.pi < input
  Time (mean ± σ):      19.0 ms ±   0.8 ms    [User: 9.2 ms, System: 9.7 ms]
  Range (min … max):    17.1 ms …  21.6 ms    125 runs
```
