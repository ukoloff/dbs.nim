import sequtils
import path, o2, rect

type
  Part* = object
    name*: string
    paths*: seq[Path]

func area*(p: Part): float =
  for z in p.paths:
    result += z.area

func perimeter*(p: Part): float =
  for z in p.paths:
    result += z.perimeter

func copy*(p: Part): Part =
  Part(name: p.name, paths: p.paths.mapIt it.copy)

func `*`*(o2: O2, p: Part): Part =
  Part(name: p.name, paths: p.paths.mapIt o2 * it)

func bounds*(p: Part): Rect =
  result.init
  for path in p.paths:
    result += path.bounds
