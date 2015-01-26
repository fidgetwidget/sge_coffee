#= require ../../lib/entity/Entity

TILE_SIZE = 16
WALL_OFFSET = TILE_SIZE * 5
SIDE_WIDTH = TILE_SIZE * 2

class @GGJPart extends Entity

  name: ''
  game: undefined
  scene: undefined
  parts: undefined
  collider: undefined
  wide: 0
  high: 0


  constructor: (name, game, scene, room) ->
    super(name, game, scene)
    @room = room
    @type = 'GGJPart'
    @init()


  init: () =>
    @collider = new BoxCollider(this)
    @parts = new PIXI.DisplayObjectContainer()


  ready: () =>
    switch @name
      when 'wall'
        left = @_x
        right = @_x + @width
        halfCanvas = @game.canvas.width * 0.5
        @high = 3
        fillNeeded = @wide
        @xoffset = 0
        
        # test for side adjacency
        
        if left is WALL_OFFSET
          lwj = new PIXI.Sprite.fromFrame('obs_leftWallJoin.png')
          lwj.x = -SIDE_WIDTH
          @xoffset = SIDE_WIDTH
          @parts.addChild lwj
        else 
          if left > halfCanvas
            lw = new PIXI.Sprite.fromFrame('obs_leftEdgeRight.png')
            fillNeeded -= 1
          else
            lw = new PIXI.Sprite.fromFrame('obs_leftEdgeLeft.png')
            lw.anchor.x = 1
            @xoffset = TILE_SIZE
          @parts.addChild lw

        if right is @game.canvas.width - WALL_OFFSET
          rwj = new PIXI.Sprite.fromFrame('obs_rightWallJoin.png')
          rwj.anchor.x = 1
          rwj.position.x = right - @x + SIDE_WIDTH
          @parts.addChild rwj
        else
          if right >= halfCanvas
            rw = new PIXI.Sprite.fromFrame('obs_rightEdgeRight.png')
            rw.anchor.x = 0
            rw.position.x = right - @x + rw.width
          else
            rw = new PIXI.Sprite.fromFrame('obs_rightEdgeLeft.png')
            fillNeeded -= 1
            rw.position.x = right - @x 
          rw.anchor.x = 1
          @parts.addChild rw

        for i in [0...fillNeeded] by 1
          x = if left <= halfCanvas or left is WALL_OFFSET then i else i + 1
          p = new PIXI.Sprite.fromFrame('obs_middle.png')
          p.position.x = x * TILE_SIZE
          @parts.addChild p

        @parts.x = @_x
        @parts.y = @_y
        @collider.width = @wide * TILE_SIZE
        @collider.height = TILE_SIZE
        @collider.offset.y = TILE_SIZE

      when 'hole'
        # TODO: build the hole sprite
        true

    @isReady = true

  unload: () =>
    # remove anything that was added in the ready

  update: (delta) =>
    # Do some state changing stuff here?

  render: () =>
    # change animation if state changed

  _getX: () =>
    return @_x + @room.x

  _getY: () =>
    return @_y + @room.y

  _getWidth: () =>
    return @wide * 16

  _getHeight: () =>
    return @high * 16

