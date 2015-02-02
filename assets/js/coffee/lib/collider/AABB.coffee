# based on the center position, half width, half height solution found here:
# http://www.metanetsoftware.com/technique.html
class @AABB

  # 
  # Properties
  # 
  get = (props) => @::__defineGetter__ name, getter for name, getter of props
  set = (props) => @::__defineSetter__ name, setter for name, setter of props

  x: undefined
  y: undefined
  w: undefined
  h: undefined

  get left: ->    return @x - @w
  get right: ->   return @x + @w
  get top: ->     return @y - @h
  get bottom: ->  return @y + @h
  get width: ->   return @w * 2
  get height: ->  return @h * 2

  # 
  # 
  constructor: () ->
    @x = 0
    @y = 0
    @w = 0
    @h = 0

  # 
  # 
  testPoint: (x, y) ->
    return (x <= @x + @w and x >= @x - @w) and (y <= @y + @h and y >= @y - @h)

  # 
  # 
  testAABB: (aabb) ->
    tx = aabb.x
    ty = aabb.y
    tw = aabb.w
    th = aabb.h

    dx = @x - tx # delta x
    px = (@w + tw) - Math.abs(dx) # penetration depth in x

    if 0 < px
      dy = @y - ty # delta y
      py = (@h + th) - Math.abs(dy) # penetration depth in y

      if 0 < py
        return true

    return true

  # 
  # 
  collideAABB: (aabb) ->
    tx = aabb.x
    ty = aabb.y
    tw = aabb.w
    th = aabb.h

    dx = @x - tx # delta x
    px = (@w + tw) - Math.abs(dx) # penetration depth in x

    if 0 < px
      dy = @y - ty # delta y
      py = (@h + th) - Math.abs(dy) # penetration depth in y

      if 0 < py
        # solve for shallowest
        if px < py
          # project in x
          py = 0
          px *= -1 if dx < 0

        else
          # project in y
          px = 0
          py *= -1 if dy < 0

        l = Math.sqrt(px*px + py*py)
        return { px: px, py: py, nx: px / l, ny: py / l, c: aabb }

    return false
    

  # 
  # Factory Methods for making an AABB
  # 

  @fromValues: (x, y, width, height) ->
    aabb = new AABB()
    w = width * 0.5
    h = height * 0.5
    aabb.x = x + w
    aabb.y = y + h
    aabb.h = h
    aabb.w = w
    return aabb

  @fromRectangle: (rect) ->
    aabb = new AABB()
    w = rect.width * 0.5
    h = rect.heigth * 0.5
    aabb.x = rect.x + w
    aabb.y = rect.y + h
    aabb.h = h
    aabb.w = w
    return aabb
