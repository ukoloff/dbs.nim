import macros

macro hi() =
  quote:
    echo "Hello, world!"

hi()
