# Day 5: [If You Give A Seed A Fertilizer](https://adventofcode.com/2023/day/5)
*Picat: [Part 1](https://github.com/DestyNova/advent_of_code_2023/blob/main/5/part1.pi) (00:52:17, rank 6717), [Part 2](https://github.com/DestyNova/advent_of_code_2023/blob/main/5/part2.pi) (03:20:27, rank 7231)*

## Part 1

Getting slightly more complicated now! It took a little while to understand what we needed to do, and then began the parsing. I keep saying I'll figure out DCGs in Picat, and then not doing it. Instead, I ended up using `split` a bunch of times and pattern matching in a recursive predicate that adds everything to a map.

## Part 2

This is where it got hairy. I couldn't see how it would be remotely possible to bruteforce this; even though the numbers weren't "black hole time", it was enough to seemingly take many hours or even days. Others apparently reported bruteforcing it in a few minutes, so either I was doing something silly or they were multithreading it up the wazoo and using lower level languages with better brute-force performance.

Instead, I set about converting the problem to a constraint puzzle. It had been a while since I did one of these and I made some silly decisions -- the worst being the decision to put all seed ranges and locations in arrays and solve them all simultaneously in one pass. My assumption was that this would be quicker than searching the 10 ranges individually. But this simply didn't work, because I was minimising the array of locations, which gave me an arbitrary suboptimal result.

After a **long** time messing about, I changed the loop to just run the solver once on each seed range, solving for the minimum and keeping track of the best we've seen among all seed ranges so far. That produced the correct result in about a minute, and playing with various solver options (including the new maxsat interface and various compatible solvers) reduced this to around 35 seconds with the built-in `sat` module with the default options. Quite impressive!

The `smt` module also succeeds with either `z3` or `cvc4` but **much** slower than the in-built SAT solver (or external maxsat interfaces which are about the same as the internal solver).

**Update 22:32:** Okay, before I head to bed in preparation for the next puzzle in... 6 hours... I tried another maxsat solver called [CGSS2](https://bitbucket.org/coreo-group/cgss2). I ran into a build error which the maintainer fixed almost immediately, and CGSS2 produced the quickest (correct) result I've seen so far, in 28.853 seconds. Very cool indeed.

## Thoughts

Once again, Picat's built-in SAT solver is magic. The program I ended up with after some tidying up looks relatively clean, but formulating it correctly took several hours with really confusing results, including negative values when using `cp`, (which I thought would be impossible). A lot of the time, doing something wrong will produce a nondescript error like `*** error(failed,main/0)` with no clues about where the flow of execution was, no stacktrace or line numbers even.

Another example is adding this line (it was necessary to get anywhere with the MIP solvers):

```picat
    Ds[I] #>= 0,
    Ds[I] mod 1 #= 0,
```

If the `mod` line is left in when using the `sat` solver module, the program crashes with:

```
*** error(syntax_error,parse_term([m,a,p,:]))
```

Again, no stacktrace or line numbers to give any clue as to what specifically the problem was. `cp` doesn't seem to care since it handles constraints very differently. Using the `smt` module does provide a clue:

```
*** error(unknown_constraint,$mod_constr(_230,1,_238,0,[arith_constr(ge,-1,[(-1,0),(1,1)]),$mul_constr(1,_238,_2f0),arith_constr(eq,0,[(-1,_230),(1,_2f0),(1,0)])]))
```

But... well you get the idea. Invariably I ended up manually bisecting the code with `println(ok1), ....., println(ok2)` to see where something goes wrong. Perhaps this is unavoidable in Prolog-flavoured languages, but it can lead to being stuck for quite a while.

Also it's often hard to reason about what the constraint solver expects and why your program isn't working. For a while I was stuck just trying to express that a domain variable `D` should exist which is an element of an array of domain vars `Ds`. This just did not seem to work at all -- the `::` operator refused to accept it, and the closest I got was `element(I,Ds,D), I :: 1..Ds.len`.

I'm sure that with more regular practice with these problems, I can eventually become comfortable with translating complex problems into the constraint language. It's taking a while though.

## Timings (with hyperfine)

### Part 1

```
Benchmark 1: picat ./part1.pi < input
  Time (mean ± σ):      16.0 ms ±   0.9 ms    [User: 6.6 ms, System: 9.3 ms]
  Range (min … max):    14.4 ms …  20.2 ms    154 runs
```

### Part 2

Nah, too slow for that, but rough timings of the original version are:

* ~35s with Picat's built-in SAT solver, defaulting to `split` strategy
* ~35s with the `seq` strategy
* 28.5953s with `maxsat`, where a symlink of that name somewhere in my `$PATH` points to the [CGSS2 solver](https://bitbucket.org/coreo-group/cgss2)
* >5m30s (cancelled at about 20%) with z3
* 32.11s with the `CASHWMAXSAT-CorePlus-m` solver and `seq`, and 31.58s with `split`
* 28.4s with [maxino](https://maxsat-evaluations.github.io/2017/mse17-solver-src/complete/maxino.zip) (2017 version)
* 31.9 with [WMaxCDCL](https://maxsat-evaluations.github.io/2023/mse23-solver-src/exact/WMaxCDCL.zip)

With some optimisations suggested by [Hakan Kjellerstrand](http://hakank.org), the time came down to:

* 20.534s with the `maxino` maxsat solver
* 27.777s with the built-in `sat` module and the default solver options
* 28.058s with `sat` and the `seq` strategy
