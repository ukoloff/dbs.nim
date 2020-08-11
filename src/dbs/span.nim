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

proc sqr(x: float): float =
  x * x

proc isArc*(s: Span): bool =
  s.bulge != 0

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
  let q = ((9 + 8 * sqr(s.bulge)).sqrt + 1) / 4
  s[pos / (q - (q - 1) * sqr(pos))]

proc zenith*(s: Span): Point =
  s[Point(y: -s.bulge)]

proc nadir*(s: Span): Point =
  s[Point(y: 1 / s.bulge)]

proc center*(s: Span): Point =
  s[Point(y: (1 / s.bulge - s.bulge) / 2)]

proc area*(s: Span): float =
  result = (s.z.x * s.a.y - s.z.y * s.a.x) / 2
  if s.isArc:
    let b2 = sqr(s.bulge)
    result -= (arctan(s.bulge) * sqr(1 + b2) - (1 - b2) * s.bulge) /
      b2 / 8 * s.vector.abs2

proc perimeter*(s: Span): float =
  result = s.vector.abs
  if s.isArc:
    result *= arctan(s.bulge) / s.bulge * (1 + sqr(s.bulge))
