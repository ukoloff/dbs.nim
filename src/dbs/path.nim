import node, span

type
  Path* = seq[Node]
  SpanPtr = ptr Span

proc isClose*(path: Path): bool =
  true

iterator spans*(path: Path): Span =
  yield cast[SpanPtr](path[0].unsafeAddr)[]
