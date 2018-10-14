discard """
  errormsg: "'=' is not available for type <Foo>; requires a copy because it's not the last read of 'otherTree'"
  line: 44
"""

type
  Foo = object
    x: int

proc `=destroy`(f: var Foo) = f.x = 0
proc `=`(a: var Foo; b: Foo) {.error.} # = a.x = b.x
proc `=sink`(a: var Foo; b: Foo) = a.x = b.x

proc createTree(x: int): Foo =
  Foo(x: x)

proc take2(a, b: sink Foo) =
  echo a.x, " ", b.x

proc allowThis() =
  var otherTree: Foo
  for i in 0..3:
    while true:
      #if i == 0:
      otherTree = createTree(44)
      case i
      of 0:
        echo otherTree
        take2(createTree(34), otherTree)
      of 1:
        take2(createTree(34), otherTree)
      else:
        discard

proc preventThis() =
  var otherTree: Foo
  for i in 0..3:
    while true:
      if i == 0:
        otherTree = createTree(44)
      case i
      of 0:
        echo otherTree
        take2(createTree(34), otherTree)
      of 1:
        take2(createTree(34), otherTree)
      else:
        discard
