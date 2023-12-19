# Day 19: [Aplenty](https://adventofcode.com/2023/day/19)
*Picat: [Part 1](https://github.com/DestyNova/advent_of_code_2023/blob/main/19/part1.pi) (01:04:01, rank 4202), [Part 2](https://github.com/DestyNova/advent_of_code_2023/blob/main/19/part2.pi) (06:58:08, rank 6371)*

## Part 1

Not a grid puzzle! Part 1 was reasonably straightforward, albeit with quite a bit of time spent on reading comprehension.

## Part 2

Now we're talking... it took me almost 6 more hours to get part 2 working. Initially, I thought there might be a way to do it with Picat's CP or SAT solvers, despite previously running into problems trying to solve "how many possibilities" puzzles this way.

Converting the part 1 `should_accept` predicate to work with the solver's domain variables was easier than expected, but... while I could discover and constrain solutions easily, there was still no obvious way to count all possible solutions without actually enumerating all of them.

I tried a few things, including converting the sample workflows by hand into a single boolean expression of integer inequalities and substituting the ands and ors with `+` and `*`, among other things. None of these worked.

After a few hours I was running out of time and my wife suggested it was time to go take a walk. Being too lazy to take a walk, I went for a shower and thought about the problem a bit. Much earlier I had thought of trying a DFS to find every accepting (terminal) state and combine the counts together, and after picking up that train of thought again, a plan emerged.

Some 20 minutes later I finally had a working version, passing around four arrays of length 4000 which serve as wasteful bitvectors so I could narrow the domains of each variable upon entry to new branches of the search space (i.e. the next rule within a workflow, jumping to another workflow, or encountering a terminal state `A` or `R`). This worked but was incredibly ugly and took 300 ms to return an answer. This version is in `part2_slow.pi`.

On chat, Dmitry Ivanov pointed out that since we're only narrowing intervals (rather than punching holes in the variables' domains nonlinearly), we just need to pass around four ranges. The improved version is in `part2.pi`, cuts out 40 lines of code, and completes with the right answer in 30 ms.

## Timings (with hyperfine)

### Part 2, `{Lo,Hi}` range-narrowing version

```
Benchmark 1: picat part2.pi < input
  Time (mean ± σ):      28.2 ms ±   0.7 ms    [User: 16.8 ms, System: 11.3 ms]
  Range (min … max):    26.6 ms …  30.7 ms    87 runs
```
