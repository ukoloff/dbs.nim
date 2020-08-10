import math

import point

type
  Span* = object
    a*: Point
    bulge*: float
    z*: Point
  SpanPtr* = ptr Span

static:
  assert Span.sizeof == 2 * Point.sizeof + float.sizeof

proc vector(s: Span): Point =
  s.z - s.a

proc radius*(s: Span): float =
  s.vector.abs * abs(1 / s.bulge + s.bulge) / 4

proc `[]`(s: Span, pos: Point): Point =
  (s.vector * pos + s.a + s.z) / 2

## Position on the span: -1 = A; +1 = Z
proc `[]`*(s: Span, pos: float): Point =
  s[Point(x: pos, y: -s.bulge) / Point(y: 1 / s.bulge - s.bulge)]

## Position on the Span but more uniform then []
proc at*(s: Span, pos: float): Point =
  let q = ((9 + 8 * s.bulge * s.bulge).sqrt + 1) / 4
  s[pos / (q - (q - 1) * pos * pos)]

proc zenith*(s: Span): Point =
  s[Point(y: -s.bulge)]

proc nadir*(s: Span): Point =
  s[Point(y: 1 / s.bulge)]

proc center*(s: Span): Point =
  s[Point(y: 1 / s.bulge - s.bulge)]
