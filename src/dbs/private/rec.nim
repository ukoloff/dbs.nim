#
# DBS records
# https://github.com/ukoloff/dbs.js/wiki/DBS
#
import strutils
import ".." / [node]

type
  Padding = distinct int16 ## = 0

  ## Common record prologue
  R0* = object
    size*:   int16
    id2*:    int16
    size2*:  int16
    x1:      Padding
    typ*:    int16
    x2:      Padding
    id*:     int16
    x3:      Padding

  ## Part name
  R26* = object
    name: array[8, char]

  ## Area + Perimeter
  R27* = object
    area*:       float32
    perimeter*:  float32

  ## Bind contour to Part
  R8* = object
    id*: int16
    x1:  Padding

  Point = object
    x, y: float32

  O2 = object
    x, y, delta: Point

  ## Copy of Part
  R2* = object
    sybtype*:  int16
    x1*:       Padding
    text*:     int16
    x2*:       Padding
    autoseq*:  int16
    x3*:       Padding
    part*:     int16
    x4*:       Padding
    original*: int16
    x5*:       Padding
    rev*:      int16
    x6*:       Padding
    o2*:       O2

  ## Point of contour
  R1* = object
    x, y, bulge:  float32

func isEOF*(r: R0): bool =
  r.size < 0

func bytes*(r: R0): int =
  (r.size.int + 1) * 4

func payload*(r: R0): int =
  (r.size.int + 1) * 4 - r.sizeof

proc init*(r: var R0, typ: int16, payload = 0) =
  r.typ = typ
  r.size = ((payload + r.sizeof + 3) / 4 - 1).int16

proc swap*(r: var R26) =
  for i in countup(1 + r.name.low, 1 + r.name.high, 2):
    swap(r.name[i-1], r.name[i])

proc `$`*(r: var R26): string =
  r.name.join().strip()

proc init*(r: var R26, s: string) =
  for i in 0..<r.name.len:
    r.name[i] = if i < s.len: s[i] else: ' '

proc init(o2: var O2) =
  o2.x.x = 1
  o2.y.y = 1

proc init*(r2: var R2) =
  r2.o2.init()

proc init*(r1: var R1, node: Node) =
  r1.x = node.point.x
  r1.y = node.point.y
  r1.bulge = node.bulge
