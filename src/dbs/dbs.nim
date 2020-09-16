import sequtils
import part, o2, rect

type
  DBS* = seq[Part]

func area*(d: DBS): float =
  for z in d:
    result += z.area

func perimeter*(d: DBS): float =
  for z in d:
    result += z.perimeter

func copy*(d: DBS): DBS =
  d.mapIt it.copy

func `*`*(o2: O2, d: DBS): DBS =
  d.mapIt o2 * it

func bounds*(d: DBS): Rect =
  result.init
  for part in d:
    result += part.bounds
