import point

type
  Node* = object
    point*: Point
    bulge*: float

static:
  doAssert Node.sizeof == Point.sizeof + float.sizeof
