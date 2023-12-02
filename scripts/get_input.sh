#!/usr/bin/env bash

DAY=$(basename $(pwd))
YEAR=2023

curl --cookie "session=$(<../../session.txt)" https://adventofcode.com/$YEAR/day/$DAY/input > input
