#= require_tree ../collider 

class @Entity

  # 
  # Properties
  # 
  get = (props) => @::__defineGetter__ name, getter for name, getter of props
  set = (props) => @::__defineSetter__ name, setter for name, setter of props

  name:     ''
  type:     'Entity'
  game:     undefined
  scene:    undefined
  collider: undefined
  states:   undefined
  isReady:  false
  scale: {}

  get x: ->               return @_getX()
  set x: (value) ->       return @_setX(value)
  get y: ->               return @_getY()
  set y: (value) ->       return @_setY(value)
  get width: ->           return @_getWidth()
  set width: (value) ->   return @_setWidth(value)
  get height: ->          return @_getHeight()
  set height: (value) ->  return @_setHeight(value)
  get anchor: ->          return @_getAnchor()
  set anchor: (value) ->  return @_setAnchor(value)
  get scale: ->           return @_getScale()
  set scale: (value) ->   return @_setScale(value)
  get centerX: ->         return @_getCenterX()
  get centerY: ->         return @_getCenterY()
  get aabb: ->            return @_getAABB()

  # defined below
  _x: 0
  _y: 0
  _width: 0
  _height: 0
  _anchor: undefined
  _scale: undefined


  # 
  # Constructor
  # 
  constructor: (@name, @game, @scene) ->
    return console.warn 'Entity needs game to function.' unless @game
    @resetValues()
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
    @_anchor ?= {}
    @_anchor.x = 0
    @_anchor.y = 0
    @scale ?= {}
    @_scale.x = 1
    @_scale.y = 1

  update: () =>
    # update loop for changing state

  render: () =>
    # render loop for changing animation

  # Property Getters / Setters

  _getX: () =>            return @_x
  _setX: (value) =>       return @_x = value

  _getY: () =>            return @_y
  _setY: (value) =>       return @_y = value

  _getWidth: () =>        return @_width
  _setWidth: (value) =>   return @_width = value

  _getHeight: () =>       return @_height
  _setHeight: (value) =>  return @_height = value

  _getAnchor: () =>       return @_anchor
  _setAnchor: (value) =>  return @_anchor = value

  _getScale: () =>        return @_scale
  _setScale: (value) =>   return @_scale = value
  
  _getCenterX: () =>      return @x + ((0.5 - @anchor.x) * @width * @scale.x)
  _getCenterY: () =>      return @y + ((0.5 - @anchor.y) * @height * @scale.y)
  
  _getAABB: () =>         return if @collider then @collider.aabb else null
    
    