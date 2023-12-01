# Day 1: [Trebuchet?!](https://adventofcode.com/2023/day/1)
*Picat: [Part 1](https://github.com/DestyNova/advent_of_code_2023/blob/main/1/part1.pi) (00:13:46, rank 6439), [Part 2](https://github.com/DestyNova/advent_of_code_2023/blob/main/1/part2.pi) (00:39:06, rank 4467)*

## Part 1

A fairly simple problem to kick off the season. I was a bit rusty with Picat and... well, thinking in general, so ran into some basic issues while getting started. I'd forgotten that there is no built-in regex support in Picat, so after giving up on that I switched to just manually filtering the digits with a list comprehension.

Afterwards I discovered that there is a [binding for PCRE regex support](https://github.com/hakank/picat_regex) written by Hakan Kjellerstrand, so I'll be able to try that for future parsing. I should really start figuring out DCGs which seem to be a more elegant way to construct parsers in Prolog-flavoured languages.

## Part 2

Again I lamented the lack of regexes in Picat, but in this case it would have probably let me further astray. As it was, I got stuck for about 10 minutes with the correct answer on the sample input but the wrong answer on the full input. After a while I mentioned it on my Discord server's channel for the puzzles, and someone gave me a crucial hint: "try the input `eightwo`".

At first I thought this was simply invalid input, but then the spec didn't strictly specify that they had to be separate words. It didn't take long to fix it after understanding the issue, but... that was quite a tough subtle twist for a day 1 puzzle! Perhaps the difficulty curve will be stepped up this year -- let's see. There were a couple of 10+ hour slogs in recent years but maybe some of what I learned will stick.

## Timings (with hyperfine)

### Part 1

```
Benchmark 1: picat ./part1.pi < input
  Time (mean ± σ):      20.4 ms ±   1.1 ms    [User: 9.9 ms, System: 10.5 ms]
  Range (min … max):    18.4 ms …  25.2 ms    105 runs
```

### Part 2

```
Benchmark 1: picat ./part2.pi < input
  Time (mean ± σ):      23.8 ms ±   1.1 ms    [User: 12.7 ms, System: 11.0 ms]
  Range (min … max):    21.8 ms …  27.0 ms    105 runs
```
