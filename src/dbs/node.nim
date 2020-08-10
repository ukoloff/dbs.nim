import point

type
  Node* = object
    point*: Point
    bulge*: float

static:
  assert Node.sizeof == Point.sizeof + float.sizeof
