import node, span

type
  Path* = seq[Node]

proc isClose*(path: Path): bool =
  path.len > 0 and path[0].point == path[^1].point

iterator spans*(path: Path): SpanPtr =
  for i in 1 ..< path.len:
    yield cast[SpanPtr](path[i - 1].unsafeAddr)

proc area*(p: Path): float =
  if p.isClose:
    for z in p.spans:
      result += z[].area

proc perimeter*(p: Path): float =
  for z in p.spans:
    result += z[].perimeter
