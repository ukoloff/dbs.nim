type
  Point* = object
    x*, y*: float

proc `+`*(a, b: Point): Point =
  Point(x: a.x + b.x, y: a.y + b.y)

proc `-`*(a, b: Point): Point =
  Point(x: a.x - b.x, y: a.y - b.y)

proc `*`*(pt: Point, by: float): Point =
  Point(x: pt.x * by, y: pt.y * by)

proc `*`*(by: float, pt: Point): Point =
  Point(x: pt.x * by, y: pt.y * by)

proc `/`*(pt: Point, by: float): Point =
  Point(x: pt.x / by, y: pt.y / by)

proc `/`*(by: float, pt: Point): Point =
  Point(x: pt.x / by, y: pt.y / by)
