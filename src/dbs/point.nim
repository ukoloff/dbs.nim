import math

type
  Point* = object
    x*, y*: float

static:
  doAssert Point.sizeof == 2 * float.sizeof

proc abs2*(pt: Point): float =
  pt.x * pt.x + pt.y * pt.y

proc abs*(pt: Point): float =
  sqrt(pt.abs2)

# Conjugate
proc `~`*(pt: Point): Point =
  Point(x: pt.x, y: - pt.y)

proc `==`*(a, b: Point): bool =
  a.x == b.x and a.y == b.y

proc `+`*(a, b: Point): Point =
  Point(x: a.x + b.x, y: a.y + b.y)

proc `-`*(a, b: Point): Point =
  Point(x: a.x - b.x, y: a.y - b.y)

proc `*`*(pt: Point, by: float): Point =
  Point(x: pt.x * by, y: pt.y * by)

proc `*`*(by: float, pt: Point): Point =
  pt * by

proc `*`*(a, b: Point): Point =
  Point(x: a.x * b.x - a.y * b.y, y: a.x * b.y + a.y * b.x)

proc `/`*(pt: Point, by: float): Point =
  Point(x: pt.x / by, y: pt.y / by)

proc `/`*(a, b: Point): Point =
  a * ~b / b.abs2

proc `/`*(by: float, pt: Point): Point =
  Point(x: by) / pt
