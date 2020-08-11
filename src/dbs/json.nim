import std/[json, sequtils]

import point, node, path, part, dbs

proc asJson*(n: Node): JsonNode =
  %*[n.point.x, n.point.y, n.bulge]

proc newNode*(j: JsonNode): Node =
  assert(j.kind == JArray and j.len > 1, "Invalid JSON for DBS node")
  Node(
    point: Point(x: j[0].getFloat, y:j[1].getFloat),
    bulge: if j.len > 2: j[2].getFloat else: 0
  )

proc asJson*(p: Path): JsonNode =
  %*p.map(asJson)

proc newPath*(j: JsonNode): Path =
  assert(j.kind == JArray, "Invalid JSON for DBS contour")
  result = newSeqOfCap[Node](j.len)
  for n in j.items:
    result.add(newNode(n))

proc asJson*(p: Part): JsonNode =
  %*{
    "partid": p.name,
    "paths": map(p.paths, asJson)
  }

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

proc asJson*(d: DBS): JsonNode =
  %*map(d, asJson)

proc newDBS*(j: JsonNode): DBS =
  assert(j.kind == JArray, "Invalid JSON for DBS file")
  result = newSeqOfCap[Part](j.len)
  for n in j.items:
    result.add(newPart(n))
