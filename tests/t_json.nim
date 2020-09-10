import json as JSON, unittest

import dbs/[json]
import geodet

suite "JSON":

  test "forth & back":

    let z = geodet.asDBS

    echo z.asJson.pretty
    echo $z.asJson
    echo z.toJson
    echo z.toJson false

    check $z.asJson == z.toJson false

    echo z.toYaml
