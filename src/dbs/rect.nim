import math
import point

type
  Rect* = object
    a*, z*: Point

proc init*(r: var Rect) =
  r.a.x = NaN

func isEmpty*(r: Rect): bool =
  r.a.x.classify == fcNan

func bounds*(p: Point): Rect =
  result.a = p
  result.z = p

func bounds*(r: Rect): Rect =
  r

proc `+=`*(r: var Rect, p: Point) =
  if r.isEmpty:
    r = p.bounds
  else:
    if r.a.x > p.x:
      r.a.x = p.x
    if r.a.y > p.y:
      r.a.y = p.y
    if r.z.x < p.x:
      r.z.x = p.x
    if r.z.y < p.y:
      r.z.y = p.y

proc `+=`*(r: var Rect, other: Rect) =
  if not other.isEmpty:
    r += other.a
    r += other.z

func `+`*[T](r: Rect, p: T): Rect =
  result = r
  result += p
