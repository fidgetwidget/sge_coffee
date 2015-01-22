
# Pythagarus 
Math.distanceBetween = (aX, aY, bX, bY) ->
  return Math.sqrt( Math.distanceBetweenSquared(aX, aY, bX, bY) )

Math.distanceBetweenSquared = (aX, aY, bX, bY) ->
  x = Math.abs(bX - aX)
  y = Math.abs(bY - aY)
  a = x*x
  b = y*y
  return a + b
