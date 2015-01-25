
class Vector

  x: 0
  y: 0
  length2: 0

  constructor: (x=0, y=0) ->
    @x = x
    @y = y
    @length2 = (x * x) + (y * y)


  normalize: () ->
    l = Math.sqrt(@length2)
    @x = @x / l
    @y = @y / l


