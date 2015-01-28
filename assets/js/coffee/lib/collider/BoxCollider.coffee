
class @BoxCollider extends @BaseCollider


  constructor: (entity) ->
    super(entity)


  testAABB: (aabb) => 
    return @aabb.testAABB(aabb)
    

  collideAABB: (aabb) => 
    return @aabb.collideAABB(aabb)


  @fromValues: (entity, x, y, width, height) =>
    box = new BoxCollider(entity)
    box.offset.x  = x
    box.offset.y  = y
    box.width     = width
    box.height    = height
    return box
