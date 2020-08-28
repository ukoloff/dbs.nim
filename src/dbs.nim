# This is just an example to get you started. A typical library package
# exports the main API in this file. Note that you cannot rename this file
# but you can remove it if you wish.

import dbs/dbs

export DBS

when isMainModule:
  echo "int is ", int.sizeof,  " bits."
  echo "ptr is ", (ptr int).sizeof,  " bits."
