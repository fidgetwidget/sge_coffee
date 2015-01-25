#= require ../../lib/entity/Entity


WALL_OFFSET = 16 * 5
SIDE_WIDTH = 16 * 2

class @GGJPart extends Entity

  wide: 0 # in tiles (16 pixels)
  high: 0 # in tiles (16 pixels)

  constructor: (name, game, scene) ->
    super(name, game, scene)
    @type = 'GGJPart'


  init: () =>
    @collider = new BoxCollider(this)
    @sprite = new PIXI.DisplayObjectContainer()


  ready: () =>
    switch @name
      when 'wall'
        left = @_x
        right = @_x + (@wide * 16)
        halfCanvas = @game.canvas.width * 0.5
        @high = 3
        fillNeeded = @wide
        
        # test for side adjacency
        
        if left is WALL_OFFSET
          lwj = new PIXI.Sprite.fromFrame('obs_leftWallJoin.png')
          lwj.x = -SIDE_WIDTH
          @sprite.addChild lwj
        else 
          if left > halfCanvas
            lw = new PIXI.Sprite.fromFrame('obs_leftEdgeRight.png')
            lw.position.x = -16
          else
            lw = new PIXI.Sprite.fromFrame('obs_leftEdgeLeft.png')
            lw.position.x = 0
            fillNeeded -= 1

          @sprite.addChild lw

        if right is @game.canvas.width - WALL_OFFSET
          rwj = new PIXI.Sprite.fromFrame('obs_rightWallJoin.png')
          rwj.anchor.x = 1
          rwj.position.x = right - @_x + SIDE_WIDTH
          @sprite.addChild rwj
        else
          if right > halfCanvas
            rw = new PIXI.Sprite.fromFrame('obs_rightEdgeRight.png')
            rw.position.x = right - @_x - 16
          else
            rw = new PIXI.Sprite.fromFrame('obs_rightEdgeLeft.png')
            fillNeeded -= 1
            rw.position.x = right - @_x 
          rw.anchor.x = 1
          @sprite.addChild rw

        for i in [0...fillNeeded] by 1
          x = if left > halfCanvas or left is WALL_OFFSET then i else i + 1
          p = new PIXI.Sprite.fromFrame('obs_middle.png')
          p.position.x = x * 16
          @sprite.addChild p

        @collider.width = @wide * 16
        @collider.height = 16
        @collider.offset.y = 32

      when 'hole'
        # TODO: build the hole sprite
        true

    @isReady = true


  unload: () =>
    while @children.length > 0
      child = @children.pop()
      @sprite.removeChild(child)


  update: (delta) =>
    # Do some state changing stuff here?


  render: () =>
    # change animation if state changed

