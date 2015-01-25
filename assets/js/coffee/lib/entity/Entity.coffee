#= require_tree ../collider 

class @Entity

  name:     ''
  type:     'Entity'
  game:     undefined
  scene:    undefined
  sprite:   undefined
  collider: undefined
  states:   undefined
  _x: 0
  _y: 0
  isReady:  false


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


  getBounds: () =>
    if @collider
      return @collider.getBounds()
    else
      return null

  # TODO: put basic collision handling into the entitiy, rather than the sprite

Object.defineProperty Entity::, "x",
  get: ->
    return if @sprite then @sprite.x else @_x

  set: (value) ->
    if @sprite
      @sprite.x = value
    return @_x = value

Object.defineProperty Entity::, "y",
  get: ->
    return if @sprite then @sprite.y else @_y

  set: (value) ->
    if @sprite
      @sprite.y = value
    return @_y = value
    