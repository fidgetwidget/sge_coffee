#= require ../../lib/entity/Entity

class @GGJPlayer extends Entity

  prevState: 0
  currentState: 0


  constructor: (game, scene) ->
    super('GGJPlayer', game, scene)
    @type = 'GGJPlayer'


  init: () =>
    @collider = new BoxCollider(this)
    @collider.width = 16
    @collider.height = 16
    

  ready: () =>
    @sprite = PIXI.Sprite.fromFrame('player')
    @sprite.anchor.x = 0.5
    @sprite.anchor.y = 0.5
    @scene.stage.addChild(@sprite)
    @x = (@game.canvas.width * 0.5) - (@sprite.width * 0.5)
    @y = (@game.canvas.height * 0.5) - (@sprite.height * 0.5)
    @isReady = true


  update: (delta) =>
    # Do some state changing stuff here?


  render: () =>
    # change animation if state changed
