# Day 3: [Gear Ratios](https://adventofcode.com/2023/day/3)
*Picat: [Part 1](https://github.com/DestyNova/advent_of_code_2023/blob/main/3/part1.pi) (00:52:18, rank 5989), [Part 2](https://github.com/DestyNova/advent_of_code_2023/blob/main/3/part2.pi) (01:17:47, rank 5818)*

## Part 1

Oh this was ugly. I couldn't think of a neat, functional way to pull out the numbers and surrounding symbols, so wrote the most imperative, 1980s Commodore 64 v2 BASIC-style loop you're likely to see, updating a string buffer as digits are discovered, then pushing them onto the numbers list if a nearby symbol is seen.

About 10-15 minutes was spent trying to understand why the sample worked but not the full input. It turned out I was only handling a "complete" number when encountering the next non-digit, which meant any numbers that touched the right edge of the grid were never added to the list. Oops.

## Part 2

This required a slight rethink to how I was looking for numbers, but ultimately it wasn't a huge change, and it simplified the logic a bit:

* When processing a number:
  * Search for adjacent `*` characters and...
  * Accumulate a list of their coordinates in the grid.
* When the number has been completely read:
  * Push that number onto the list of numbers adjacent to each of the accumulated `*` positions (in a map).
* At the end:
  * Take all lists of numbers in the ratio map which have exactly two elements
  * Multiply the pairs
  * Sum the result

This is one of those problems where I should have taken 5 minutes at the start to think that through before just plowing ahead, but... you know.

## Timings (with hyperfine)

### Part 1

```
Benchmark 1: picat ./part1.pi < input
  Time (mean ± σ):      51.1 ms ±   1.0 ms    [User: 38.6 ms, System: 12.4 ms]
  Range (min … max):    49.2 ms …  52.9 ms    54 runs
```

### Part 2

```
Benchmark 1: picat ./part2.pi < input
  Time (mean ± σ):      46.0 ms ±   0.8 ms    [User: 35.6 ms, System: 10.4 ms]
  Range (min … max):    44.4 ms …  47.8 ms    60 runs
```
