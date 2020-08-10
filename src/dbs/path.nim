import node, span

type
  Path* = seq[Node]

proc isClose*(path: Path): bool =
  path.len > 0 and path[0].point == path[^1].point

iterator spans*(path: Path): SpanPtr =
  yield cast[SpanPtr](path[0].unsafeAddr)
