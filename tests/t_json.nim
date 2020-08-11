import unittest, json

import dbs/json as jjj

suite "JSON":

  test "forth & back":

    let z = """
      [{
        "partid": "ROUNDED3",
        "paths": [
        [
        [0, 1, 0],
        [0, 3, -0.414213],
        [1, 4, 0],
        [2, 4, -0.414213],
        [3, 3, 0],
        [3, 1, -0.414213],
        [2, 0, 0],
        [1, 0, -0.414213],
        [0, 1, 0]]
      ]}]
    """.parseJson.newDBS

    echo z.asJson.pretty
