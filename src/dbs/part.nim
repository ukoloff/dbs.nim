import path

type
  Part* = object
    name*: string
    paths*: seq[Path]

proc area*(p: Part): float =
  for z in p.paths:
    result += z.area

proc perimeter*(p: Part): float =
  for z in p.paths:
    result += z.perimeter
