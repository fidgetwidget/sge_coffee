#= require ../../lib/entity/Entity

class @GGJPlayer extends Entity

  prevState: 0
  currentState: 0
  sprite: undefined

  constructor: (game, scene) ->
    super('GGJPlayer', game, scene)
    @type = 'GGJPlayer'


  init: () =>
    @collider = new BoxCollider(this)
    @collider.width = 16
    @collider.height = 32
    @collider.offset.y = -12
    

  ready: () =>
    @sprite ?= PIXI.Sprite.fromFrame('player')
    @sprite.anchor.x = 0.5
    @sprite.anchor.y = 1
    @x = (@game.canvas.width * 0.5)
    @y = (@game.canvas.height * 0.5)
    @sprite.x = @x
    @sprite.y = @y
    @scene.midground.addChild(@sprite)
    @isReady = true

  unload: () =>
    @scene.midground.removeChild(@sprite)
    @isReady = false


  update: () =>
    # Do some state changing stuff here?


  render: () =>
    @sprite.x = @x
    @sprite.y = @y
    # change animation if state changed


  die: () =>
    @scene.reset()
