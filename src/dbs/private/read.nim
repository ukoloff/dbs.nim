import streams, tables
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
    parts: seq[int16]
    particles: Table[int16, Particle]
    r1s: seq[Path]
    r2s: seq[R2]

proc init*(r: var Reader, src: Stream) =
  r.src = src

proc readPath(r: var Reader) =
  let
    payload = r.rec.payload
  if r.rec.typ == 2:
    doAssert payload == 0, "Path copy contains geometry"
  doAssert payload >= R2.sizeof and 0 == (payload - R2.sizeof) mod R1.sizeof,
    "Invalid Path count"
  var
    r2: R2
  r.src.read r2
  if r.rec.typ == 1:
    var
      path: Path
    path.newSeq (payload - R2.sizeof) div R1.sizeof
    for i in 0..<path.len:
      var r1: R1
      r.src.read r1
      r1.toNode path[i]

proc read8(r: var Reader) =
  let count = r.rec.payload div R8.sizeof
  for i in 0..<count:
    var r8: R8
    r.src.read r8

proc read26(r: var Reader) =
  var r26: R26
  doAssert r.rec.payload == R26.sizeof, "Invalid Record #26"
  r.src.read r26
  r26.swap

proc read*(r: var Reader): DBS =
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
