import streams
import dbs
import private/[read, write]

proc write*(dbs: DBS, dst: Stream) =
  var writer: Writer
  writer.init dst
  writer.write dbs

proc newDBS*(src: Stream): DBS =
  var reader: Reader
  reader.init src
  return reader.read
