import os, json as Json, strutils, streams, unittest

import dbs/[point, json, io]

const
  src = currentSourcePath.parentDir.joinPath("../geodet/rounded3x4.json").staticRead.strip

suite "Write DBS":
  test "Compiles":
    var
      dst = newStringStream()
      d = src.parseJson.newDBS
    d.write(dst)
