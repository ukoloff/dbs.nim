import streams
import rec
import ".." / [dbs, part, path]

type
  Writer* = object
    dst: Stream
    rec: R0

  ## Pass Part info to Path
  PathContext = object
    part: int
    index: int

proc init*(writer: var Writer, dst: Stream) =
  writer.dst = dst

## Write EOF
proc writeEOF*(writer: var Writer) =
  writer.rec.size = -1
  for i in 1..2:
    writer.dst.write writer.rec.size
  writer.dst.flush()

## Prepare new DBS record
proc next*(writer: var Writer, typ: int16, payload = 0) =
  writer.rec.init typ, payload

proc inc(writer: var Writer) =
  writer.rec.id.inc

## Write DBS record
proc writeRecord*(writer: var Writer) =
  writer.rec.id2 = writer.rec.id
  writer.rec.size2 = writer.rec.size
  writer.dst.write(writer.rec)

proc write*(writer: var Writer, path: Path, ctx: PathContext) =
  writer.next 1, R2.sizeof + path.len * R1.sizeof
  writer.writeRecord
  var r2: R2
  r2.init
  r2.part = (if ctx.index > 0: ctx.part else: -ctx.part).int16
  r2.original = writer.rec.id
  writer.dst.write r2
  for node in path:
    var r1: R1
    r1.init node
    writer.dst.write r1

proc write*(writer: var Writer, part: Part) =
  var
    ctx: PathContext
  ctx.part = writer.rec.id + part.paths.len + 1
  for i, path in part.paths:
    writer.inc
    ctx.index = i
    writer.write path, ctx
  writer.inc
  doAssert ctx.part == writer.rec.id, "Failed enumerating part's paths"

  block partName:
    writer.next 27, R26.sizeof
    var r26: R26
    r26.init part.name
    r26.swap
    writer.writeRecord
    writer.dst.write r26

  block partMeasure:
    writer.next 27, R27.sizeof
    let r27 = R27(area: part.area / 1e4, perimeter: part.perimeter / 1e2)
    writer.writeRecord
    writer.dst.write r27

  block partPaths:
    writer.next 8, R8.sizeof * part.paths.len
    var r8 = R8(id: (writer.rec.id - part.paths.len).int16)
    writer.writeRecord
    for i in 0..<part.paths.len:
      writer.dst.write r8
      r8.id.inc

proc write*(writer: var Writer, dbs: DBS) =
  for part in dbs:
    writer.write part

