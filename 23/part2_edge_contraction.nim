import std/[strformat, strutils, sets]

echo "todo"
assert(false, "Not yet implemented")

type Vertex = (int,int)

var
  g: seq[string]
  seen: seq[seq[bool]]
  w,h: int = 0

proc getNeighbours(v: Vertex): seq[(Vertex)] =
  let
    (x,y) = v

  var
    vs = newSeq[Vertex]()

  for (i,j) in [(1,0),(0,1),(-1,0),(0,-1)]:
    let
      (x2,y2) = (x+i,y+j)

    #echo fmt"{x}<{w}, {y}<{h} = {g[y2][x2]}, seen"
    if 0<=x2 and x2<w and 0<y2 and y2<=h and not seen[y2][x2] and g[y2][x2] != '#':
      vs.add((x2,y2))

  return vs

var
  count = 0
  bestEver = 0

proc dfs(v: Vertex, depth: int): int =
  var
    (x,y) = v
    bestDepth = 0
    res: int

  if x == w-2 and y == h-1:
    res = depth
    if depth > bestEver:
      bestEver = depth
  else:
    count += 1
    if count mod 10000000 == 0:
      echo fmt"Step {count}, depth: {depth}, best ever: {bestEver}"

    for (i,j) in getNeighbours(v):
      seen[j][i] = true

      let d = dfs((i,j), depth+1)

      bestDepth = max(bestDepth, d)
      seen[j][i] = false

    res = bestDepth

  return res

var i: int = 0
for line in stdin.lines:
  w = len(line)
  h += 1
  g.add(line)
  seen.add(newSeq[bool](w))

echo fmt"w: {w}, h: {h}"
echo g
let
  start: Vertex = (1,0)
echo fmt"neighbours of start node: {getNeighbours(start)}"
# find junctions
# flood fill from start node, adding junctions encountered to a reachability map?
echo dfs(start,0)
