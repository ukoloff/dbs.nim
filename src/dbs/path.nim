import sequtils
import node, span, o2

type
  Path* = seq[Node]

func isClose*(path: Path): bool =
  path.len > 0 and path[0].point == path[^1].point

iterator spans*(path: Path): SpanPtr =
  for i in 1 ..< path.len:
    yield cast[SpanPtr](path[i - 1].unsafeAddr)

func area*(p: Path): float =
  if p.isClose:
    for z in p.spans:
      result += z[].area

func perimeter*(p: Path): float =
  for z in p.spans:
    result += z[].perimeter

func copy*(p: Path): Path =
  p.mapIt it

func `*`*(o2: O2, p: Path): Path =
  p.mapIt  o2 * it

proc reverted*(p: Path): Path =
  result.newSeq p.len
  for i in 0..<p.len:
    result[^(i+1)].point = p[i].point
    if i == 0:
      continue
    result[^(i+1)].bulge = -p[i-1].bulge

## Reverse Path in place
proc revert*(p: var Path) =
  for i, n in p.reverted:
    p[i] = n
