import os, unittest, json, strutils

import dbs/json as jjj

const
  src = currentSourcePath.parentDir.joinPath("../geodet/rounded3x4.json").staticRead.strip

suite "JSON":

  test "forth & back":

    let z = src.parseJson.newDBS

    echo z.asJson.pretty
    echo $z.asJson
    echo z.toJson
    echo z.toJson false

    check $z.asJson == z.toJson false

    echo z.toYaml
