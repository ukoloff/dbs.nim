import math, algorithm
import point

type
  O2* = object
    x*, y*, delta*: Point

proc init*(o2: var O2) =
  o2.reset
  o2.x.x = 1
  o2.y.y = 1

proc CCW*(o2: var O2, degrees: float) =
  let angle = degrees.degToRad
  o2.x.x = cos(angle)
  o2.x.y = sin(angle)
  o2.y.x = - o2.x.y
  o2.y.y = o2.x.x
  o2.delta.reset

proc shift*(o2: var O2, delta: Point) =
  o2.init
  o2.delta = delta

func det*(o2: O2): float =
  o2.x.x * o2.y.y - o2.x.y * o2.y.x

func isMirror*(o2: O2): bool =
  o2.det < 0

func isDegenerate*(o2: O2): bool =
  o2.det == 0

func `*`*(o2: O2, pt: Point): Point =
  o2.x * pt.x + o2.y * pt.y + o2.delta

func compose*(first: O2, others: varargs[O2]): O2 =
  var points = [Point(x:1), Point(y:1), Point()]
  for m in others.reversed & first:
    for p in points.mitems:
      p = m * p
  result.x = points[0] - points[2]
  result.y = points[1] - points[2]
  result.delta = points[2]

func `*`*(me, other: O2): O2 =
  me.compose other
