import streams
import rec
import ".." / [dbs, part, path]

type
  Writer* = object
    dst: Stream
    rec: R0

proc init*(writer: var Writer, dst: Stream) =
  writer.dst = dst

## Write EOF
proc writeEOF*(writer: var Writer) =
  writer.rec.size = -1
  writer.dst.write(writer.rec.size)
  writer.dst.write(writer.rec.size)
  writer.dst.flush()

## Prepare new DBS record
proc next*(writer: var Writer, typ: int16, payload = 0) =
  writer.rec.next typ, payload

## Write DBS record
proc writeRecord*(writer: var Writer) =
  writer.rec.id2 = writer.rec.id
  writer.rec.size2 = writer.rec.size
  writer.dst.write(writer.rec)

proc write*(writer: var Writer, path: Path) =
  var r2: R2
  writer.next 1, path.len * R1.sizeof
  r2.init()
  writer.writeRecord()
  for node in path:
    var r1: R1
    r1.init(node)
    writer.dst.write(r1)

proc write*(writer: var Writer, part: Part) =
  for path in part.paths:
    writer.write path

proc write*(writer: var Writer, dbs: DBS) =
  for part in dbs:
    writer.write part

