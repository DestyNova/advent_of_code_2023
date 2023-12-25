# Day 24: [Never Tell Me The Odds](https://adventofcode.com/2023/day/24)
*Picat: [Part 1](https://github.com/DestyNova/advent_of_code_2023/blob/main/24/part1.pi) (01:01:42, rank 1540), [Part 2](https://github.com/DestyNova/advent_of_code_2023/blob/main/24/part2.pi) (01:34:36, rank 464)*

## Part 1

Ahh, maths. Geometry again! This time simple line geometry, but I still had to remind myself of the slope and intersection formulae:

$$y = mx + c$$

and

$$d = {a_1}{b_2}-{a_2}{b_1}$$

$$(\frac {{b_1}{c_2}-{b_2}{c_1}} {d}, \frac {{a_2}{c_1}-{a_1}{c_2}} {d})$$

It seemed inefficient to compare every pair of lines with each other ($$\frac {N*(N+1)} {2}$$, $$N=300 \implies 44850$$), but computers are pretty fast. Picat produced the right answer after 215 ms.

However, it took me a **long** time to get the line comparison logic correct -- especially the bit about colliding in the future only. That is, they were directional vectors rather than infinite lines.

I ran into two other issues -- one was a division by zero in the intersection formula. I added a check for zero but it didn't prevent the crash, which suggested they were perhaps just very close to zero. In the end, I inserted this hack:

```picat
get_intersection({A1,B1,C1},{A2,B2,C2}) = R =>
  D1 = A1*B2-A2*B1,
  D2 = A1*B2-A2*B1,
  Fudge = 10000000000000000000000000000000,
  R = cond((abs(D1)*Fudge < 1 || abs(D2)*Fudge < 1), {-2**63,-2**63}, {(B1*C2-B2*C1)/D1,(A2*C1-A1*C2)/D2}).
```

The second issue was floating point accuracy loss. It might have been a good place to use the [fixed-point module](https://github.com/DestyNova/picat_fixedpoint) I wrote for Picat earlier this year while working on one of the 2015 problems, but instead I solved it by multiplying both sides of the slope formula by the divisor (`Vx`):

```picat
get_line_equation({[Px,Py,Pz],[Vx,Vy,Vz]}) = R =>
  M = Vy,
  B_vx = Vx*Py - Vy*Px,
  R = {M,-Vx,B_vx}.
```

It's always useful if you can remove division from your program if possible, since it can lead to mysterious accuracy loss. If you can stay in the domain of integers or use fixed-point arithmetic, even better. [Hakan](http://hakank.org) reminded me about this when my quadratic regression SAT program wasn't working a few days ago, and was fixed by multiplying both sides of a constraint expression by the divisor to get rid of the division.

Some resources I found to... refresh... my faded memory of school maths:

* https://www.mathcentre.ac.uk/resources/uploaded/mc-ty-strtlines-2009-1.pdf
* https://www.ncl.ac.uk/webtemplate/ask-assets/external/maths-resources/core-mathematics/geometry/equation-of-a-straight-line.html
* https://byjus.com/point-of-intersection-formula

## Part 2

Finally a day where it was immediately obvious and straightforward to solve a very difficult problem with a very simple constraint program. All that was required here was to define an array of collision times and check that each hailstone would occupy the same X/Y/Z coordinates the rock would be in at some time `T` within that array. This worked straight away on the sample data, but hadn't terminated on the full data after about 10 minutes.

Then it occurred to me we don't need to solve the collision times for all 300 hailstones -- only 3 or 4 should be enough to fix the correct trajectory for the rock. After making this change, the program produced the correct answer in around 12 seconds.

One thing I've noticed with SAT solvers is that a seemingly small change can have drastic changes on performance. For example, trying to solve based on the first 3 lines instead of 4 causes the program to take at least a minute (I killed it rather than wait to see if it completes, so maybe it made the problem unsolvable). And inlining these expressions:

```picat
    X #= Px + Vx*T,
    Cx #= Sx + Svx*T,
    X #= Cx,
```

to this:

```picat
    Px + Vx*T #= Sx + Svx*T,
```

...seemed like a perfectly equivalent expression that should produce the exact same timings and result, but again makes the program at least 10 times slower. It's very hard to predict how your changes will affect performance, but one rule of thumb seems to be that it's better to break up an expression into several separate assertions and then combine them, than to build complex expressions that mean the same thing.
Also, I found myself running 3 different versions of the program in parallel so I could test changes more quickly: [tmux](https://github.com/tmux/tmux/wiki) and companion [tmuxinator](https://github.com/tmuxinator/tmuxinator) are really useful here.

## Timings (with hyperfine)

### Part 1

```
Benchmark 1: picat part1.pi < input
  Time (mean ± σ):     214.5 ms ±   4.4 ms    [User: 166.7 ms, System: 47.2 ms]
  Range (min … max):   207.5 ms … 220.8 ms    13 runs
```

### Part 2

Too slow; 11.291 seconds with Picat's `sat` module.
