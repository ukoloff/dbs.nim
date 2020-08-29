import path

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
