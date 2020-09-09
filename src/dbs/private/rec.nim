#
# DBS records
# https://github.com/ukoloff/dbs.js/wiki/DBS
#

type
  ## Common record prologue
  R0* = object
    size:   int16
    id2:    int16
    size2:  int16
    x1:     int16 ## = 0
    typ:    int16
    x2:     int16 ## = 0
    id:     int16
    x3:     int16 ## = 0

  ## Part name
  R26* = object
    name: array[8, char]

  ## Area + Perimeter
  R27* = object
    area:       float32
    perimeter:  float32

  ## Bind contour to Part
  R8* = object
    id: int16
    x1: int16   ## = 0

  Point = object
    x, y: float32

  O2 = object
    x, y, delta: Point

  ## Copy of Part
  R2* = object
    sybtype:  int16
    x1:       int16 ## = 0
    text:     int16
    x2:       int16 ## = 0
    autoseq:  int16
    x3:       int16 ## = 0
    part:     int16
    x4:       int16 ## = 0
    original: int16
    x5:       int16 ## = 0
    rev:      int16
    x6:       int16 ## = 0
    o2:       O2

  ## Point of contour
  R1* = object
    x, y, bulge:  float32

func isEOF*(r: R0): bool =
  r.size < 0

proc swap*(r: var R26) =
  for i, _ in r.name:
    if (i and 1) != 0:
      swap(r.name[i-1], r.name[i])
