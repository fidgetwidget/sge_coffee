###
# Path
#   a list of points with helpers to travers through the list of points  
###

class @Path

  points: undefined

  # Copied from the PIXI Polygon constructor to allow for an array, or list of values
  constructor: (points) ->
    
    #if points isn't an array, use arguments as the array    
    points = Array::slice.call(arguments) unless points instanceof Array

    #if this is a flat array of numbers, convert it to points
    unless points[0] instanceof PIXI.Point
      p = []
      i = 0
      il = points.length
      while i < il
        p.push( points[i].x, points[i].y )
        i++
      points = p

    @points = points


  # Allow for PIXI.Point or x,y value args
  addPoint: (point) =>
    unless point instanceof PIXI.Point
      x = arguments[0] || 0
      y = arguments[1] || arguments[0] || 0
      point = new PIXI.Point(x, y)

    @points.push(point)

  clear: () =>
    @points.pop() while @points.length > 0


  drawPath: (graphics) =>
    p = @points[0]
    graphics.moveTo p.x, p.y

    for i in [1...@points.length] by 1
      p = @points[i]
      graphics.lineTo p.x, p.y


PIXI.Path = Path