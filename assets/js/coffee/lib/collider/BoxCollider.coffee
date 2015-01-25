
class @BoxCollider extends @BaseCollider

  _width: 0
  _height: 0

  constructor: (entity) ->
    super(entity)


  testAABB: (aabb) => return @getBounds().testAABB(aabb)
    

  collideAABB: (aabb) => return @getBounds().collideAABB(aabb)


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

