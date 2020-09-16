import streams, unittest

import dbs/[io]
import geodet

suite "DBS IO compiles":
  test "Write":
    var dst = newStringStream()
    geodet.asDBS.write dst

  test "Read":
    var src = newStringStream geodet.asBin
    discard newDBS src
