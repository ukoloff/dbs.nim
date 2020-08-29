import part

type
  DBS* = seq[Part]

func area*(d: DBS): float =
  for z in d:
    result += z.area

func perimeter*(d: DBS): float =
  for z in d:
    result += z.perimeter
