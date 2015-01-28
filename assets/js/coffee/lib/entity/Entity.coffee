#= require_tree ../collider 

class @Entity

  # 
  # Properties
  # 

  name:     ''
  type:     'Entity'
  game:     undefined
  scene:    undefined
  collider: undefined
  states:   undefined
  isReady:  false
  scale: {}

  # defined below
  _x: 0
  _y: 0
  _width: 0
  _height: 0
  _anchor: {x: 0, y: 0}
  _scale: {x: 1, y: 1}


  # 
  # Constructor
  # 
  constructor: (@name, @game, @scene) ->
    return console.warn 'Entity needs game to function.' unless @game
    @init()


  init: () =>
    # setup anything that should onyl happen once

  ready: () =>
    # setup stuff that can be unlaoded later

  unload: () =>
    # reset anything that was done in the ready

  resetValues: () =>
    @_x = 0
    @_y = 0
    @_width = 0
    @_height = 0
    @_anchor.x = 0
    @_anchor.y = 0
    @_scale.x = 1
    @_scale.y = 1

  update: () =>
    # update loop for changing state

  render: () =>
    # render loop for changing animation


  getAABB: () =>
    if @collider
      return @collider.getAABB()
    else
      return null


  # Property Getters / Setters

  _getX: () =>
    return @_x
  _setX: (value) =>
    return @_x = value

  _getY: () =>
    return @_y
  _setY: (value) =>
    return @_y = value

  _getWidth: () =>
    return @_width
  _setWidth: (value) =>
    return @_width = value

  _getHeight: () =>
    return @_height
  _setHeight: (value) =>
    return @_height = value

  _getAnchor: () =>
    return @_anchor
  _setAnchor: (value) =>
    return @_anchor = value

  _getScale: () =>
    return @_scale
  _setScale: (value) =>
    return @_scale = value

  _getCenterX: () =>
    return @x + ((0.5 - @anchor.x) * @width * @scale.x)
  _getCenterY: () =>
    return @y + ((0.5 - @anchor.y) * @height * @scale.y)


Object.defineProperty Entity::, "x",
  get: -> 
    return @_getX()
  set: (value) -> 
    return @_setX(value)

Object.defineProperty Entity::, "y",
  get: -> 
    return @_getY()
  set: (value) -> 
    return @_setY(value)

Object.defineProperty Entity::, "width",
  get: -> 
    return @_getWidth()
  set: (value) -> 
    return @_setWidth(value)

Object.defineProperty Entity::, "height",
  get: -> 
    return @_getHeight()
  set: (value) -> 
    return @_setHeight(value)

Object.defineProperty Entity::, "anchor",
  get: ->
    return @_getAnchor()
  set: (value) ->
    return @_setAnchor(value)

Object.defineProperty Entity::, "scale",
  get: ->
    return @_getScale()
  set: (value) ->
    return @_setScale(value)

Object.defineProperty Entity::, "centerX",
  get: -> 
    return @_getCenterX()

Object.defineProperty Entity::, "centerY",
  get: -> 
    return @_getCenterY()

    