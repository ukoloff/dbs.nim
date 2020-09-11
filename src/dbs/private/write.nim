import streams
import rec
import ".." / [dbs, part, path]

type
  Writer* = object
    dst: Stream
    rec: R0

  ## Pass Part info to Path
  PathContext = object
    part:   int
    index:  int

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

## Write DBS record
proc writeRecord*(writer: var Writer) =
  writer.rec.id2 = writer.rec.id
  writer.rec.size2 = writer.rec.size
  writer.dst.write(writer.rec)

proc write*(writer: var Writer, path: Path, ctx: PathContext) =
  var r2: R2
  writer.next 1, path.len * R1.sizeof
  r2.init()
  writer.writeRecord()
  for node in path:
    var r1: R1
    r1.init(node)
    writer.dst.write r1

proc write*(writer: var Writer, part: Part) =
  var
    ctx: PathContext
  ctx.part = writer.rec.id + part.paths.len + 1
  for i, path in part.paths:
    ctx.index = i
    writer.write path, ctx

  # doAssert ctx.part == writer.rec.id, "Failed enumerating part's paths"

proc write*(writer: var Writer, dbs: DBS) =
  for part in dbs:
    writer.write part

