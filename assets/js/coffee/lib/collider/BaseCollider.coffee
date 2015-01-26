
class @BaseCollider

  # 
  # Properties
  # 

  x: undefined
  y: undefined
  entity: undefined
  offset: undefined
  _aabb:   undefined

  
  constructor: (entity) ->
    @entity = entity
    @offset = new PIXI.Point()
    @_aabb = new AABB()


  getAABB: () =>
    @_aabb.x = @x
    @_aabb.y = @y
    return @_aabb


  testAABB: (aabb) => 
    return false
    

  collideAABB: (aabb) => 
    return false


cx = 0
cy = 0


Object.defineProperty BaseCollider::, "x",
  get: -> 
    cx = @entity.x + (@entity.width * @entity.scale.x * 0.5)
    return cx + @offset.x

Object.defineProperty BaseCollider::, "y",
  get: -> 
    cy = @entity.y + (@entity.height * @entity.scale.y * 0.5)
    return cy + @offset.y
    
