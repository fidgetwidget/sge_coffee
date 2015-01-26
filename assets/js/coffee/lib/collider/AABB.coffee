
# based on the center position, half width, half height solution found here:
# http://www.metanetsoftware.com/technique.html
class @AABB

  x: undefined
  y: undefined
  w: undefined
  h: undefined

  constructor: () ->
    @x = 0
    @y = 0
    @w = 0
    @h = 0


  testPoint: (x, y) ->
    return (x <= @x + @w and x >= @x - @w) and (y <= @y + @h and y >= @y - @h)


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


  # to prevent junk from being made 
  #  TODO: move these to global variables for better memory use
  tx = 0
  ty = 0
  tw = 0
  th = 0
  dx = 0
  px = 0
  dy = 0
  py = 0
  l = 0

Object.defineProperty AABB::, "left",
  get: -> return @x - @w
    
Object.defineProperty AABB::, "right",
  get: -> return @x + @w

Object.defineProperty AABB::, "top",
  get: -> return @y - @h

Object.defineProperty AABB::, "bottom",
  get: -> return @y + @h

Object.defineProperty AABB::, "width",
  get: -> return @w * 2

Object.defineProperty AABB::, "height",
  get: -> return @h * 2

