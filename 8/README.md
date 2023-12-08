# Day 8: [Haunted Wasteland](https://adventofcode.com/2023/day/8)
*Picat: [Part 1](https://github.com/DestyNova/advent_of_code_2023/blob/main/8/part1.pi) (00:12:28, rank 3276), [Part 2](https://github.com/DestyNova/advent_of_code_2023/blob/main/8/part2.pi) (00:29:12, rank 1595)*

## Part 1

Finally a graph problem! This time it wasn't a graph search but just repeated application of a cyclic path, counting steps until a target node was reached. This one went really well.

## Part 2

I had a feeling this would be one of those cases where brute-forcing takes forever, and my first solution to actually follow each path simultaneously seemed to confirm this. I thought about whether dynamic programming could be used in some way, then realised this problem was similar to the "bus schedule" problem from a past AoC. In that one, you had to line up a series of bus times with a cyclic pattern, and I solved it with some kind of modulo logic.

It occurred to me that the problem **might** be designed such that each starting node only reaches one end node, then cycles in the same number of steps. If that was the case, then you just need to get the count of steps from each starting node to its terminal node, then find the lowest common multiple (LCM) of all the counts, which is where they would all line up.

So that's what I tried. Picat doesn't have a built-in LCM function (but it does provide `gcd(A,B)`), so before coding one I just dumped the numbers into an online calculator and pasted the result, which turned out to be right. Then I added a fairly inefficient implementation that basically folds over the list, performing `gcd(Acc,Next)` with each value.

Still not top 1000 even, but I'm really glad with how this one turned out.

## Timings (with hyperfine)

### Part 1

```
Benchmark 1: picat part1.pi < input
  Time (mean ± σ):      21.1 ms ±   0.8 ms    [User: 8.7 ms, System: 12.3 ms]
  Range (min … max):    19.8 ms …  24.8 ms    104 runs
```

### Part 2

```
Benchmark 1: picat part2.pi < input
  Time (mean ± σ):      39.0 ms ±   2.3 ms    [User: 25.4 ms, System: 13.4 ms]
  Range (min … max):    36.9 ms …  47.9 ms    58 runs
```
