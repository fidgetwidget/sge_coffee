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
  _scale: {x: 1, y: 1}


  # 
  # Constructor
  # 
  constructor: (@name, @game, @scene) ->
    return console.warn 'Entitiy needs game to function.' unless @game
    @init()


  init: () =>
    #setup anything that should onyl happen once

  ready: () =>
    #setup stuff that can be unlaoded later

  unload: () =>
    #reverse the values that were set in init

  update: (delta) =>
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

  _getScale: () =>
    return @_scale
  _setScale: (value) =>
    return @_scale = value


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

Object.defineProperty Entity::, "scale",
  get: ->
    return @_getScale()
  set: (value) ->
    return @_setScale(value)

    