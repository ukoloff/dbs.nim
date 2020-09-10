import streams, unittest

import dbs/[io]
import geodet

suite "Write DBS":
  test "Compiles":
    var dst = newStringStream()
    geodet.asDBS.write dst
