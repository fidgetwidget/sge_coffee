
class @BaseCollider

  entity: undefined
  offset: undefined
  _aabb:   undefined

  constructor: (entity) ->
    @entity = entity
    @offset = new PIXI.Point()
    @_aabb = new AABB()


  getBounds: () =>
    @_aabb.x = @x
    @_aabb.y = @y
    return @_aabb


  testAABB: (aabb) => 
    return false
    

  collideAABB: (aabb) => 
    return false



Object.defineProperty BaseCollider::, "x",
  get: -> return @entity.x + @offset.x
    


Object.defineProperty BaseCollider::, "y",
  get: -> return @entity.y + @offset.y
    
