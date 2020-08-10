import unittest

import dbs/point

suite "Point":

  test "can add":
    check Point(x:1, y: 2) + Point(x:3, y: 4) == Point(x: 4, y: 6)

  test "can subtract":
    check Point(x:1, y: 2) - Point(x:3, y: 4) == Point(x: -2, y: -2)

  test "can multiple":
    check Point(x:1, y: 2) * Point(x:3, y: 4) == Point(x: -5, y: 10)
    check Point(x:1, y: 2) * 3 == Point(x: 3, y: 6)
    check -1 * Point(x:3, y: 4) == Point(x: -3, y: -4)
    check Point() * Point(x:3, y: 4) == Point()
    let p = Point(x: 3, y: 4)
    check p * ~p == Point(x: p.abs2)

  test "can divide":
    check Point(x:1, y: 2) / Point(x:3, y: 4) == Point(x: 11 / 25, y: 2 / 25)
    check Point(x:1, y: 2) / 3 == Point(x: 1 / 3, y: 2 / 3)
    check 1 / Point(x:3, y: 4) == Point(x: 3 / 25, y: -4 / 25)
