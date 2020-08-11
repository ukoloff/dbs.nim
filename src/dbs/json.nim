import std/[json, sequtils, strutils, strformat]

import point, node, path, part, dbs

# DBS => JsonNode

proc asJson*(n: Node): JsonNode =
  %*[n.point.x, n.point.y, n.bulge]

proc asJson*(p: Path): JsonNode =
  %*p.map(asJson)

proc asJson*(p: Part): JsonNode =
  %*{
    "partid": p.name,
    "paths": map(p.paths, asJson)
  }

proc asJson*(d: DBS): JsonNode =
  %*map(d, asJson)

# JsonNode => DBS

proc newNode*(j: JsonNode): Node =
  assert(j.kind == JArray and j.len > 1, "Invalid JSON for DBS node")
  Node(
    point: Point(x: j[0].getFloat, y:j[1].getFloat),
    bulge: if j.len > 2: j[2].getFloat else: 0
  )

proc newPath*(j: JsonNode): Path =
  assert(j.kind == JArray, "Invalid JSON for DBS contour")
  result = newSeqOfCap[Node](j.len)
  for n in j.items:
    result.add(newNode(n))

proc newPart*(j: JsonNode): Part =
  assert(j.kind == JObject and j.contains("partid") and j.contains("paths"),
    "Invalid JSON for DBS part")
  let src = j{"paths"}
  var paths = newSeqOfCap[Path](src.len)
  for n in src.items:
    paths.add(newPath(n))
  Part(
    name: j{"partid"}.getStr,
    paths: paths
  )

proc newDBS*(j: JsonNode): DBS =
  assert(j.kind == JArray, "Invalid JSON for DBS file")
  result = newSeqOfCap[Part](j.len)
  for n in j.items:
    result.add(newPart(n))

# DBS => JSON string

proc toJson*(n: Node, pretty: bool): string =
  let space = if pretty: " " else: ""
  &"[{n.point.x},{space}{n.point.y},{space}{n.bulge}]"

proc toJson*(p: Path, pretty: bool): string =
  let space = if pretty: "\n  " else: ""
  proc fmtNode(n: Node): string =
    &"{space}{n.toJson pretty}"
  let z = p.map(fmtNode).join ","
  &"[{z}]"

proc quoteStr(s: string): string =
  $ % s

proc toJson*(p: Part, pretty: bool): string =
  let eol = if pretty: "\n  " else: ""
  proc fmtPath(p: Path): string =
    &"{eol}{p.toJson pretty}"
  let z = p.paths.map(fmtPath).join ","
  let sep = if pretty: " " else: ""
  let brk = if pretty: "\n" else: ""
  &"""{{{eol}{quoteStr "partid"}:{sep}{quoteStr p.name},{
    eol}{quoteStr "paths"}:{sep}[{z}{brk}]}}"""

proc toJson*(d: DBS, pretty = true): string =
  proc fmtPart(p: Part): string =
    p.toJson pretty
  let z = d.map(fmtPart).join ","
  &"[{z}]"
