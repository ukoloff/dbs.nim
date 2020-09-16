import point, o2

type
  Node* = object
    point*: Point
    bulge*: float

static:
  doAssert Node.sizeof == Point.sizeof + float.sizeof

func copy*(n: Node): Node =
  result = n

func `*`*(o2: O2, n: Node): Node =
  Node(
    point: o2 * n.point,
    bulge: if o2.isMirror: -n.bulge else: n.bulge
  )
