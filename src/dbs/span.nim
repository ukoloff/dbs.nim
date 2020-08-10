import point

type
  Span* = object
    a*: Point
    bulge*: float
    z*: Point
  SpanPtr* = ptr Span

static:
  assert Span.sizeof == 2 * Point.sizeof + float.sizeof
