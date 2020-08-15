import part

type
  DBS* = seq[Part]

proc area*(d: DBS): float =
  for z in d:
    result += z.area

proc perimeter*(d: DBS): float =
  for z in d:
    result += z.perimeter
