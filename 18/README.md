# Day 18: [Lavaduct Lagoon](https://adventofcode.com/2023/day/18)
*Picat: [Part 1](https://github.com/DestyNova/advent_of_code_2023/blob/main/18/part1.pi) (01:02:31, rank 3490), [Part 2](https://github.com/DestyNova/advent_of_code_2023/blob/main/18/part2.pi) (01:44:33, rank 2197)*

## Part 1

Another sort of grid puzzle. I took the naieve approach for part 1 and reused my day 10 "Pipe Maze" solution, but got the wrong answer on the full input. Rather than debug the quite horrible polygon crossing code, I just expanded the grid (which I represented as a map of coordinate to colour, allowing for negative coordinates) by one coordinate in every direction, did a flood fill of empty cells within the expanded bounds, subtracted the "slop" (expanded grid perimeter) from the filled region, and then subtracted the result from the area of the expanded region. What's left over must be the polygon and its interior.

## Part 2

Despite everything, I didn't expect this one to become a "now try it again with mega numbers" extension of part 1. Not sure if that was a relief or an "oh no"; probably both. I was kind of worrying about the ambiguous hint about filling in edges with colours in part 1, but it turned out that was a red herring to explain the presence of the colour strings.

Before I finished reading the description of part 2, someone in chat mentioned [Pick's theorem](https://brilliant.org/wiki/picks-theorem) would be needed. I had stumbled upon this while solving day 10, but it seemed complicated so I ignored it in favour of the raycasting brute-force method of calculating the interior area. Today though, I had to figure it out.

And by figure it out, I mean do a few web searches for Pick's theorem. Annoyingly, most of the results just handwaved away the difficulty of counting the interior points of the polygon. How are you meant to do that if there are trillions of interior points??

Thankfully, one of the maths pages mentioned the [Shoelace theorem](https://artofproblemsolving.com/wiki/index.php/Shoelace_Theorem) as a handy aside. I looked into this too and found that it would trivially allow us to find the area of the polygon by multiplying together adjacent X and Y coordinates in a pleasing pattern.

## Thoughts

This was a fun one and I learned some maths, although whether it will stick in my brain or not is hard to say. As with a lot of these mathy puzzles, I wonder how much people actually need to memorise these theorems and methods. I've done a couple of code tests for job interviews where you're expected to just reproduce this kind of stuff onto a whiteboard and honestly that is ridiculous. So I don't feel too bad for having to look this one up, but am glad to add it to my toolbox.

## Timings (with hyperfine)

Part 1 is too slow at around 9.6s.

### Part 2

```
Benchmark 1: picat part2.pi < input
  Time (mean ± σ):      17.0 ms ±   0.9 ms    [User: 7.5 ms, System: 9.4 ms]
  Range (min … max):    14.9 ms …  20.0 ms    130 runs
```
