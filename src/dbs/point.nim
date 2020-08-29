import math

type
  Point* = object
    x*, y*: float

static:
  doAssert Point.sizeof == 2 * float.sizeof

func abs2*(pt: Point): float =
  pt.x * pt.x + pt.y * pt.y

func abs*(pt: Point): float =
  sqrt(pt.abs2)

# Conjugate
func `~`*(pt: Point): Point =
  Point(x: pt.x, y: - pt.y)

func `==`*(a, b: Point): bool =
  a.x == b.x and a.y == b.y

func `+`*(a, b: Point): Point =
  Point(x: a.x + b.x, y: a.y + b.y)

func `-`*(a, b: Point): Point =
  Point(x: a.x - b.x, y: a.y - b.y)

func `*`*(pt: Point, by: float): Point =
  Point(x: pt.x * by, y: pt.y * by)

func `*`*(by: float, pt: Point): Point =
  pt * by

func `*`*(a, b: Point): Point =
  Point(x: a.x * b.x - a.y * b.y, y: a.x * b.y + a.y * b.x)

func `/`*(pt: Point, by: float): Point =
  Point(x: pt.x / by, y: pt.y / by)

func `/`*(a, b: Point): Point =
  a * ~b / b.abs2

func `/`*(by: float, pt: Point): Point =
  Point(x: by) / pt
