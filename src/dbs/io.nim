import streams
import dbs
import private/write

proc write*(dbs: DBS, dst: Stream) =
  var writer: Writer
  writer.init dst
  writer.write dbs
