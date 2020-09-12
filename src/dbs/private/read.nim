import streams, tables, sequtils
import rec
import ".." / [dbs, part, path]

type
  ## Future[Part] ;-)
  Particle = object
    name: string
    paths: seq[int16]

  Reader* = object
    src: Stream
    rec: R0
    particles: OrderedTable[int16, Particle]
    r1s: Table[int16, Path]
    r2s: Table[int16, R2]

proc init*(r: var Reader, src: Stream) =
  r.src = src

proc `[]`(r: var Reader, index: int16): var Particle =
  return r.particles.mgetOrPut(index, Particle())

proc readPath(r: var Reader) =
  let
    payload = r.rec.payload
  if r.rec.typ == 2:
    doAssert payload == R2.sizeof, "Path copy contains geometry"
  doAssert payload >= R2.sizeof and
    0 == (payload - R2.sizeof) mod R1.sizeof,
    "Invalid Path count"
  var
    r2: R2
  r.src.read r2
  r.r2s[r.rec.id] = r2

  if r.rec.typ != 1:
    return

  # Original contour - should reference itself
  r.r2s[r.rec.id].original = r.rec.id
  var path: Path
  path.newSeq (payload - R2.sizeof) div R1.sizeof
  for node in path.mitems:
    var r1: R1
    r.src.read r1
    r1.toNode node
  r.r1s[r.rec.id] = path

proc read8(r: var Reader) =
  var paths: seq[int16]
  paths.newSeq r.rec.payload div R8.sizeof
  for path in paths.mitems:
    var r8: R8
    r.src.read r8
    path = r8.id
  r[r.rec.id].paths = paths

proc read26(r: var Reader) =
  var r26: R26
  doAssert r.rec.payload == R26.sizeof, "Invalid Record #26"
  r.src.read r26
  r26.swap
  r[r.rec.id].name = $r26

proc parse(r: var Reader) =
  while true:
    r.src.peek(r.rec.size)
    if r.rec.isEOF:
      break
    r.src.read r.rec
    doAssert r.rec.payload >= 0, "Invalid Record size"
    case r.rec.typ
    of 1, 2:
      r.readPath
    of 8:
      r.read8
    of 26:
      r.read26
    else:
      r.src.setPosition r.src.getPosition + r.rec.payload

func getPath(r: var Reader, id: int16): Path =
  let r2 = r.r2s[id]
  result = r2.o2.toO2() * r.r1s[r2.original]
  if r2.rev != 0:
    result = result.reverted

proc read*(r: var Reader): DBS =
  r.parse

  for p in r.particles.values:
    result.add Part(
      name: p.name,
      paths: p.paths.mapIt r.getPath it
    )
