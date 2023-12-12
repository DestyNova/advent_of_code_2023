# Day 12: [Hot Springs](https://adventofcode.com/2023/day/12)
*Picat: [Part 1](https://github.com/DestyNova/advent_of_code_2023/blob/main/12/part1.pi) (01:14:55, rank 5039), [Part 2](https://github.com/DestyNova/advent_of_code_2023/blob/main/12/part2.pi) (02:20:03, rank 2553)*

## Part 1

This was an interesting problem that should have at first glance looked very combinatoric and... explodey. I felt like using CP to solve it, and had fun trying to express the constraints correctly. This time I think it did go more smoothly than before, which is nice.

## Part 2

Ahh, of course. I should have seen the twist coming: take the input and make it 5 times longer, so your naieve solutions that try to brute force calculate all possible solutions will run out of memory and time. It was obvious at this point that the numbers were big enough that enumerating all solutions with SAT/CP wasn't going to work.

I couldn't think of another way to solve it using CP, so opted to follow a hint from Discord: use DP.

It wasn't immediately obvious how to do that, but once I got the recursive non-DP version working on the sample input, then I just needed to add `table` to the `calc` predicate and Picat did the magic. Well, almost -- it uncovered some cases I hadn't considered that weren't tested by the sample input, including some bounds checking errors. Debugging those was awkward due to the lack of stacktraces, so in went the old `print(ok1)...print(ok2={Xs,L})...println(boom)` to try to localise the issues.

Before too long it was working, and pretty fast too (several times faster than part 1). Pretty happy with how this one turned out, despite going down a blind alley (see `part2_intractable_cp.pi`) and getting a hint about straight up DP.

## Timings (with hyperfine)

### Part 1

```
Benchmark 1: picat part1.pi < input
  Time (mean ± σ):      1.198 s ±  0.016 s    [User: 1.070 s, System: 0.128 s]
  Range (min … max):    1.182 s …  1.240 s    10 runs
```

### Part 2

```
Benchmark 1: picat part2.pi < input
  Time (mean ± σ):     332.8 ms ±   3.2 ms    [User: 275.7 ms, System: 56.8 ms]
  Range (min … max):   328.2 ms … 339.4 ms    10 runs
```
