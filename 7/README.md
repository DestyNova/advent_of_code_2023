# Day 7: [Camel Cards](https://adventofcode.com/2023/day/7)
*Picat: [Part 1](https://github.com/DestyNova/advent_of_code_2023/blob/main/7/part1.pi) (01:12:56, rank 8121), [Part 2](https://github.com/DestyNova/advent_of_code_2023/blob/main/7/part2.pi) (01:34:54, rank 6663)*

## Part 1

This was a fun little puzzle. After deciding how to process and represent the input, I ran into a small issue in the Picat stdlib: there doesn't seem to be a `sort_by` function that takes a comparator function -- there are options for sorting based on a "key", but I couldn't think of a sensible way to convert each hand to an absolute value that's fully orderable. Instead, I implemented the last-ditch panic sort we all know and love: bubble sort.

I also had great difficulty with the `tie_break` predicate. For whatever reason, it only works when I use Horn clauses (`head :- body`) in Picat; the usual predicate notation (`head => body`) produces the wrong result. Maybe if I read those early chapters of the Picat manual I'll understand why...

## Part 2

A cool twist on the puzzle. I decided to take the opportunity to implement an equivalent to `length <$> (group . sort)` in Haskell (this is the kind of situation where Haskell is **really** handy for manipulating lists). There's no `group` function in Picat, so I used a foreach to store a count of each element in a map, then return the down-sorted counts.

This was also an opportunity to replace the exploding pattern matches of part 2's `get_type` function, transforming from cases like this:

```picat
get_type([A,A,A,_,_]) = 4.
get_type([_,A,A,A,_]) = 4.
get_type([_,_,A,A,A]) = 4.
```

...to this:

```picat
get_type([X|_],Js) = R, X+Js == 3 => R = 4.
```

The cases with two pairs, or one pair and one three, were a bit uglier, but still nicer.

## Timings (not with hyperfine because bubble sort)

### Part 1

2.866s

### Part 2

6.162s
