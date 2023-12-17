import std/[strformat, strutils, sets, heapqueue, tables, sequtils]

type
  Coord = (int,int)
  Vertex = (int,int,int,int,int)  # player (x,y), dir, consecutive steps, total cost
  Seen = (int,int,int,int)        # dir = 0=north, 1=east, 2=south, 3=west

const
  Inf = high(int)

var
  w, h: int
  grid: seq[seq[int]]
  endCost: int

proc applyOffset(a: Coord,b: Coord): Coord =
  let
    (i,j) = a
    (dx,dy) = b
  (i+dx, j+dy)

proc getOffset(dir: int): Coord =
  [(0,-1),(1,0),(0,1),(-1,0)][dir]

proc checkTurn(dir: int, lastDir: int): bool =
  dir in [(lastDir + 3) %% 4, (lastDir + 4) %% 4, (lastDir + 5) %% 4]

proc isLegalTurn(dir: int, oldDir: int, consecutiveMoves: int, totalCost: int): bool =
  checkTurn(dir, oldDir) and ((totalCost == 0 and checkTurn(dir, oldDir)) or (consecutiveMoves >= 4 or dir == oldDir) and (consecutiveMoves < 10 or dir != oldDir))

proc getNeighbours(v: Vertex): seq[Vertex] =
  let
    (i,j,oldDir,consecutiveSteps,totalCost) = v
    endPoint = (w-1,h-1)

  var vs = newSeq[Vertex]()

  if (i,j) == endPoint: return vs # already reached the end

  for dir in [0,1,2,3]:
    let
      (dx,dy) = getOffset(dir)
      (i2,j2) = (i+dx, j+dy)
      validSpace = i2 >= 0 and i2 < w and j2 >= 0 and j2 < h
      cost = if validSpace: totalCost+grid[j2][i2] else: Inf
      legalTurn = isLegalTurn(dir, oldDir, consecutiveSteps, cost)
      consecutive = if dir == oldDir: consecutiveSteps + 1 else: 1
      newV = (i2,j2,dir,consecutive,cost)

    if validSpace and legalTurn: vs.add(newV)
  return vs

proc getApproximateOptimum(v: Vertex): int =
  let (i,j,_,_,_) = v
  w - i + h - j + endCost - 1

proc `<`(a, b: Vertex): bool =
  let
    aPossible = a[4] + getApproximateOptimum(a)
    bPossible = b[4] + getApproximateOptimum(b)
  aPossible < bPossible

proc isEndState(v: Vertex): bool =
  let (i,j,dir,consecutiveMoves,_) = v
  (i,j) == (w-1,h-1) and consecutiveMoves >= 4

proc astar(start: Vertex): int =
  var
    minCost = Inf
    q = initHeapQueue[Vertex]()
    visited = initHashSet[Seen]()
    t = 1

  q.push(start)

  while q.len > 0:
    let
      v = q.pop
      (i,j,_,_,cost) = v
      bestPossible = cost + getApproximateOptimum(v)

    if t mod 100000 == 0:
      let n = q.len
      echo fmt"Step {t}: queue size: {n}, minCost: {minCost}, visited len: {visited.len}, current guess: {bestPossible}"
    inc t

    if cost < minCost and isEndState(v):
      minCost = cost
      echo fmt"v: {v}, new minCost: {minCost}, bestPossible: {bestPossible}"

    if bestPossible < minCost:
      for u in getNeighbours(v):
        let
          uPossible = u[4] + getApproximateOptimum(u)
          seen = (u[0],u[1],u[2],u[3])
        if uPossible <= minCost and seen notin visited:
          q.push(u)
          if visited.len >= 30000000: # hopefully this won't be necessary
            visited.clear()
          visited.incl(seen)

  minCost

for line in stdin.lines:
  w = line.len
  var row: seq[int] = @[]
  for i in 0..line.len-1:
    row.add(parseInt(fmt"{line[i]}"))
  grid.add(row)
  inc h

endCost = grid[h-1][w-1]
let s0: Vertex = (0,0,1,0,0)
echo fmt"w,h: {w}, {h}, neighbours of start node: {getNeighbours(s0)}"
echo fmt"initial approximate optimum: {getApproximateOptimum(s0)}"
let moves = astar(s0)
echo moves
