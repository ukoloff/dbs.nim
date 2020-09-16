import math

import point, rect

type
  Span* = object
    a*: Point
    bulge*: float
    z*: Point
  SpanPtr* = ptr Span

static:
  doAssert Span.sizeof == 2 * Point.sizeof + float.sizeof

func sqr(x: float): float =
  x * x

func isArc*(s: Span): bool =
  s.bulge != 0

func vector(s: Span): Point =
  s.z - s.a

func radius*(s: Span): float =
  s.vector.abs * abs(1 / s.bulge + s.bulge) / 4

func `[]`(s: Span, pos: Point): Point =
  (s.vector * pos + s.a + s.z) / 2

## Position on the span: -1 = A; +1 = Z
func `[]`*(s: Span, pos: float): Point =
  s[Point(x: pos, y: -s.bulge) / Point(y: 1 / s.bulge - s.bulge)]

## Position on the Span but more uniform then []
func at*(s: Span, pos: float): Point =
  let q = ((9 + 8 * sqr(s.bulge)).sqrt + 1) / 4
  s[pos / (q - (q - 1) * sqr(pos))]

func zenith*(s: Span): Point =
  s[Point(y: -s.bulge)]

func nadir*(s: Span): Point =
  s[Point(y: 1 / s.bulge)]

func center*(s: Span): Point =
  s[Point(y: (1 / s.bulge - s.bulge) / 2)]

func area*(s: Span): float =
  result = (s.z.x * s.a.y - s.z.y * s.a.x) / 2
  if s.isArc:
    let b2 = sqr(s.bulge)
    result -= (arctan(s.bulge) * sqr(1 + b2) - (1 - b2) * s.bulge) /
      b2 / 8 * s.vector.abs2

func perimeter*(s: Span): float =
  result = s.vector.abs
  if s.isArc:
    result *= arctan(s.bulge) / s.bulge * (1 + sqr(s.bulge))

func signum*(f: float): int8 =
  int8 f.cmp 0

func signum*(p: Point): array[2, int8] =
  [p.x.signum, p.y.signum]

func bounds*(s: Span): Rect =
  result = s.a.bounds + s.z.bounds
  if s.isArc:
    var
      straight = s.vector
      curve = Point(x: 1, y: -s.bulge)
      outs: int8
    curve *= curve
    for i in 0..1:
      let
        s2 = straight.signum
        t2 = (straight * curve).signum
      for j in 0..<t2.len:
        if t2[j] != 0 and t2[j] != s2[j]:
          outs += 1'i8 shl (j + 1 + t2[j])
      if i == 0:
        # Go to other end of Span
        straight = -straight
        curve = ~curve
    if outs == 0:
      return
    let
      radius = s.radius
      center = s.center
    if (outs and 1) != 0:
      result.a.x = center.x - radius
    if (outs and 2) != 0:
      result.a.y = center.y - radius
    if (outs and 4) != 0:
      result.z.x = center.x + radius
    if (outs and 8) != 0:
      result.z.y = center.y + radius
