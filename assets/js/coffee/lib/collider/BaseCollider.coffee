
class @BaseCollider

  # 
  # Properties
  # 
  get = (props) => @::__defineGetter__ name, getter for name, getter of props
  set = (props) => @::__defineSetter__ name, setter for name, setter of props

  entity: undefined
  offset: undefined

  get x: ->               return @_getX()
  set x: (value) ->       return @_setX(value)
  get y: ->               return @_getY()
  set y: (value) ->       return @_setY(value)
  get width: ->           return @_getWidth()
  set width: (value) ->   return @_setWidth(value)
  get height: ->          return @_getHeight()
  set height: (value) ->  return @_setHeight(value)
  get aabb: ->            return @_getAABB()

  _aabb:    undefined
  _width:   0
  _height:  0

  
  constructor: (entity) ->
    @entity = entity
    @offset = new PIXI.Point()
    @_aabb = new AABB()

  testAABB: (aabb) => 
    return false
    

  collideAABB: (aabb) => 
    return false


  _getX: () =>      return @entity.centerX + @offset.x
  _setX: (value) => 
    @offset.x = value - @entity.centerX
    return @x

  _getY: () =>      return @entity.centerY + @offset.y
  _setY: (value) =>
    @offset.y = value - @entity.centerY
    return @y

  _getWidth: () =>  return @_width
  _setWidth: (value) =>
    @_aabb.w = value * 0.5
    return @_width = value

  _getHeight: () => return @_height
  _setHeight: (value) =>
    @_aabb.h = value * 0.5
    return @_height = value

  _getAABB: () => 
    @_aabb.x = @x
    @_aabb.y = @y
    return @_aabb
