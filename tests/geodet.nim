import os, json as Json, strutils

import dbs/json

const
  asStr* = currentSourcePath.parentDir.joinPath("../geodet/rounded3x4.json").staticRead.strip

let
  asJson* = asStr.parseJson
  asDBS* = asJson.newDBS
