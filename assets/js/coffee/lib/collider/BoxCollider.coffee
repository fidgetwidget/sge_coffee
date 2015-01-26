
class @BoxCollider extends @BaseCollider

  _width: 0
  _height: 0

  constructor: (entity) ->
    super(entity)


  testAABB: (aabb) => 
    return @getAABB().testAABB(aabb)
    

  collideAABB: (aabb) => 
    return @getAABB().collideAABB(aabb)


  @fromValues: (entity, x, y, width, height) =>
    box = new BoxCollider(entity)
    box.offset.x = x
    box.offset.y = y
    box.width = width
    box.height = height
    return box


Object.defineProperty BoxCollider::, "width",
  get: -> return @_width

  set: (value) ->
    @_aabb.w = value * 0.5
    return @_width = value


Object.defineProperty BoxCollider::, "height",
  get: -> return @_height

  set: (value) ->
    @_aabb.h = value * 0.5
    return @_height = value

