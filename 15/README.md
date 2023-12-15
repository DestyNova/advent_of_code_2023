# Day 15: [Lens Library](https://adventofcode.com/2023/day/15)
*Picat: [Part 1](https://github.com/DestyNova/advent_of_code_2023/blob/main/15/part1.pi) (00:09:45, rank 3422), [Part 2](https://github.com/DestyNova/advent_of_code_2023/blob/main/15/part2.pi) (00:38:35, rank 3198)*

## Part 1

An unexpectedly easy part 1 on day 15. Calculate a very simple hash for each of a set of strings and sum them.

## Part 2

My intuition told me to expect some sort of seemingly-intractable brute-force puzzle like reversing hash codes given some constraints. But nope, it was a very simple and straightforward algorithm. I lost some time due to writing:

```
if Op == "-" then
```
Instead of:
```
if Op == '-' then
```
...which is one of those situations where static typechecking would have pointed the problem out very quickly and clearly. Then I used the box ID, instead of the lens label, when removing a label from a box -- with the result that nothing was removed from the box, causing the end result to be too big.

Apart from that, today was a quick one and I'm going back to bed.

## Timings (with hyperfine)

### Part 1

```
Benchmark 1: picat part2.pi < input
  Time (mean ± σ):      24.9 ms ±   0.8 ms    [User: 14.6 ms, System: 10.2 ms]
  Range (min … max):    23.5 ms …  27.6 ms    103 runs
```

### Part 2

```
Benchmark 1: picat part2.pi < input
  Time (mean ± σ):      24.8 ms ±   0.7 ms    [User: 14.3 ms, System: 10.5 ms]
  Range (min … max):    23.3 ms …  26.7 ms    102 runs
```
