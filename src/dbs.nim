# This is just an example to get you started. A typical library package
# exports the main API in this file. Note that you cannot rename this file
# but you can remove it if you wish.

import dbs/dbs

export DBS

proc add*(x, y: int): int =
  ## Adds two files together.
  return x + y
