# Day 11: [Cosmic Expansion](https://adventofcode.com/2023/day/11)
*Picat: [Part 1](https://github.com/DestyNova/advent_of_code_2023/blob/main/11/part1.pi) (01:29:15, rank 8745), [Part 2](https://github.com/DestyNova/advent_of_code_2023/blob/main/11/part2.pi) (01:50:44, rank 8166)*

Both parts took me far longer than they should have. I started by using Floyd-Warshall to determine shortest distances between all pairs of nodes in the grid, which was okay on the sample input but would take possibly years to complete on the full input. Then I switched to BFS and it was still way too slow.

My comment in yesterday's writeup was prescient:

> Sometimes you can get so bogged down thinking about a specific solution that a more elegant and simpler alternative can escape your attention. Not sure how to get better at that, other than practice and learning from other people's solutions I guess.

Thankfully someone on Discord gave me a crucial hint that seems so obvious now: there are no doors in space, so the shortest path will be the exact same as the Manhattan distance. D'oh!

That allowed me to dump half my code and complete part 1 in reasonable time (0.055s).

For part 2, my naieve "duplicate blank rows / columns" approach wasn't going to work, so I changed that function to collect each row's "height" and each column's width. These would be 1 if that row or column has galaxies in it, or 1000000 if not. Then in the distance calculation, sum the widths of traversed columns and heights of traversed rows.

It's slowish, taking 2 seconds on this machine, but it works.