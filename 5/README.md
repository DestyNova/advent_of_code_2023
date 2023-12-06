# Day 5: [If You Give A Seed A Fertilizer](https://adventofcode.com/2023/day/5)
*Picat: [Part 1](https://github.com/DestyNova/advent_of_code_2023/blob/main/5/part1.pi) (00:52:17, rank 6717), [Part 2](https://github.com/DestyNova/advent_of_code_2023/blob/main/5/part2.pi) (03:20:27, rank 7231)*

## Part 1

Getting slightly more complicated now! It took a little while to understand what we needed to do, and then began the parsing. I keep saying I'll figure out DCGs in Picat, and then not doing it. Instead, I ended up using `split` a bunch of times and pattern matching in a recursive predicate that adds everything to a map.

## Part 2

This is where it got hairy. I couldn't see how it would be remotely possible to bruteforce this; even though the numbers weren't "black hole time", it was enough to seemingly take many hours or even days. Others apparently reported bruteforcing it in a few minutes, so either I was doing something silly or they were multithreading it up the wazoo and using lower level languages with better brute-force performance.

Instead, I set about converting the problem to a constraint puzzle. It had been a while since I did one of these and I made some silly decisions -- the worst being the decision to put all seed ranges and locations in arrays and solve them all simultaneously in one pass. My assumption was that this would be quicker than searching the 10 ranges individually. But this simply didn't work, because I was minimising the array of locations, which gave me an arbitrary suboptimal result.

After a **long** time messing about, I changed the loop to just run the solver once on each seed range, solving for the minimum and keeping track of the best we've seen among all seed ranges so far. That produced the correct result in about a minute, and playing with various solver options (including the new maxsat interface and various compatible solvers) reduced this to around 35 seconds with the built-in `sat` module with the default options. Quite impressive!

The `smt` module also succeeds with either `z3` or `cvc4` but **much** slower than the in-built SAT solver (or external maxsat interfaces which are about the same as the internal solver).

**Update 22:32:** Okay, before I head to bed in preparation for the next puzzle in... 6 hours... I tried another maxsat solver called [Loandra](https://github.com/jezberg/loandra). I ran into a build error which the maintainer fixed almost immediately, and Loandra produced the quickest (correct) result I've seen so far, in 28.853 seconds. Very cool indeed.

## Thoughts

Once again, Picat's built-in SAT solver is magic. The program I ended up with after some tidying up looks relatively clean, but formulating it correctly took several hours with really confusing results, including negative values when using `cp`, (which I thought would be impossible). A lot of the time, doing something wrong will produce a nondescript error like `*** error(failed,main/0)` with no clues about where the flow of execution was, no stacktrace or line numbers even.

Invariably I ended up with code full of `println(ok1), ....., println(ok2)` to see where something goes wrong. Perhaps this is unavoidable in Prolog-flavoured languages, but it can lead to being stuck for quite a while.

Also it's often hard to reason about what the constraint solver expects and why your program isn't working. For a while I was stuck just trying to express that a domain variable `D` should exist which is an element of an array of domain vars `Ds`. This just did not seem to work at all -- the `::` operator refused to accept it, and the closest I got was `element(I,Ds,D), I :: 1..Ds.len`.

I'm sure that more regular practice with these problems, I can eventually become comfortable with translating complex problems into the constraint language. It's taking a while though.

## Timings (with hyperfine)

### Part 1

```
Benchmark 1: picat ./part1.pi < input
  Time (mean ± σ):      16.0 ms ±   0.9 ms    [User: 6.6 ms, System: 9.3 ms]
  Range (min … max):    14.4 ms …  20.2 ms    154 runs
```

### Part 2

Nah, too slow for that.
