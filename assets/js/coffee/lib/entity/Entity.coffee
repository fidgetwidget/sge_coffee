#= require_tree ../collider 

class @Entity

  name:     ''
  type:     'Entity'
  game:     undefined
  scene:    undefined
  collider: undefined
  states:   undefined
  x: 0
  y: 0
  width: 0
  height: 0
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


  getAABB: () =>
    if @collider
      return @collider.getAABB()
    else
      return null
    