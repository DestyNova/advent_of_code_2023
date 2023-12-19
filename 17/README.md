# Day 17: [Clumsy Crucible](https://adventofcode.com/2023/day/17)
*Picat: [Part 1](https://github.com/DestyNova/advent_of_code_2023/blob/main/17/part1.pi) (00:35:38, rank 2030), [Part 2](https://github.com/DestyNova/advent_of_code_2023/blob/main/17/part2.pi) (00:42:51, rank 1812)*

## Part 1

Another grid puzzle, this time a straight up pathfinding + constraints. Given we're only choosing from the 4 cardinal directions here, I should have picked up my Dijkstra code in Nim from last year, but decided to try the Picat planner.

Selecting the appropriate variant of `best_plan[_(bin|bb|unbounded)]` was not obvious -- some of them seemed to show continual progress towards an optimal solution, but all of them were very slower. In the end I ran several variations in parallel, and the `best_plan_unbounded` version finished in just under an hour (!!!). We'll come back to it later...

## Part 2

The modifications for part 2 actually made the search problem easier since it was now more heavily constrained. However, it still took around 26 minutes.

## Part 2 in Nim

While waiting for that version to complete, I pulled out my Nim code from last year's "Blizzard Basin" problem (2022 day 24) and started munging it to work with this puzzle. It took a little while since I hadn't touched Nim in a while. But I was really glad to get help from the typechecker -- plus the compiler error messages seem to have improved significantly in Nim 2.0.0, so a lot of the work was just "make a change, build, wait for compiler errors to tell me what to fix". It makes me wish for something as powerful as Picat but with (low friction) static types and type inference.

Anyway, while working on the Nim solution, the Picat version finished with the right answer. This still felt slow, so I watched [Hyperneutrino's video](https://www.youtube.com/watch?v=2pDSooPLLkI) walking through a solution also using Dijkstra. Two big optimisations for my own code immediately became apparent:

1. Picat version: Instead of including the list of the previous 11 directions in the vertex definition, just store the count of consecutive moves, incrementing it by one when continuing straight ahead, and resetting it to one when changing direction. This seems really obvious in retrospect, but hey. That change reduced my Picat part 2 runtime to 23 seconds.
2. Nim version: Don't include the current cost in the states we store in the visited set! Including it means the search can encounter loops that take a lot of time to break out of. We know there is no reason to ever visit the same grid tile more than once. Removing it dropped the runtime from around 5 minutes down to 548 ms. Pretty cool.

# Back to Picat: Dijkstra / A*

Afterwards, I made another Picat version `part2_dijkstra.pi` which replaces the `planner` module with a basic Dijkstra implementation built on Picat's `new_min_heap()`. This time we get the correct answer in around 2 minutes.

I also tried A* in `part2_astar.pi` but it takes almost 4 minutes. I'm not really sure why -- maybe I'm doing it wrong, but it's basically the same as my Nim version which runs in half a second.

## Timings (with hyperfine)

### Part 2, Nim version

```
Benchmark 1: ./part2 < input                        
  Time (mean ± σ):     548.7 ms ±  30.2 ms    [User: 454.6 ms, System: 93.6 ms]
  Range (min … max):   528.4 ms … 632.2 ms    10 runs
```
