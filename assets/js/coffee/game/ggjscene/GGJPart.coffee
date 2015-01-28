#= require ../../lib/entity/Entity

TILE_SIZE   = 16
WALL_OFFSET = TILE_SIZE * 5
SIDE_WIDTH  = TILE_SIZE * 2


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
    left = @_x
    right = @_x + @width
    halfCanvas = @game.canvas.width * 0.5

    switch @name

      # 
      # WALL
      # 
      when 'wall'    
        @high = 3
        fillWide = @wide
        xoffset = 0
        
        # test for side adjacency
        # left side
        if left is WALL_OFFSET
          lwj = new PIXI.Sprite.fromFrame('obs_leftWallJoin.png')
          lwj.x = -SIDE_WIDTH
          xoffset = SIDE_WIDTH
          @parts.addChild lwj
        else 
          if left > halfCanvas
            lp = new PIXI.Sprite.fromFrame('obs_leftEdgeRight.png')
            fillWide -= 1
          else
            lp = new PIXI.Sprite.fromFrame('obs_leftEdgeLeft.png')
            lp.anchor.x = 1
            xoffset = TILE_SIZE
          @parts.addChild lp

        # right side
        if right is @game.canvas.width - WALL_OFFSET
          rwj = new PIXI.Sprite.fromFrame('obs_rightWallJoin.png')
          rwj.anchor.x = 1
          rwj.position.x = right - @x + SIDE_WIDTH
          @parts.addChild rwj
        else
          if right < halfCanvas
            rp = new PIXI.Sprite.fromFrame('obs_rightEdgeLeft.png')
            fillWide -= 1
            rp.position.x = right - @x 
          else
            rp = new PIXI.Sprite.fromFrame('obs_rightEdgeRight.png')
            rp.anchor.x = 0
            rp.position.x = right - @x + rp.width
          rp.anchor.x = 1
          @parts.addChild rp

        # fill
        for i in [0...fillWide] by 1
          x = if left <= halfCanvas or left is WALL_OFFSET then i else i + 1
          p = new PIXI.Sprite.fromFrame('obs_middle.png')
          p.position.x = x * TILE_SIZE
          @parts.addChild p

        @parts.x = @_x
        @parts.y = @_y
        @collider.width = @wide * TILE_SIZE
        @collider.height = TILE_SIZE
        @collider.offset.y = TILE_SIZE

      # 
      # HOLE 
      # 
      when 'hole'
        fillWide = @wide - 2
        fillHigh = @high - 2
        xoffset = 0

        # test for side leaning
        # left side
        if left > halfCanvas
          tlp = new PIXI.Sprite.fromFrame('hole_topLeftEmpty.png')
          @parts.addChild tlp
          
          if fillHigh > 0
            for i in [0...fillHigh] by 1
              lp = new PIXI.Sprite.fromFrame('hole_middleLeftEmpty.png')
              lp.position.y = (i+1) * TILE_SIZE
              @parts.addChild lp
          
          blp = new PIXI.Sprite.fromFrame('hole_bottomLeftEmpty.png')
          blp.anchor.y = 1
          blp.position.y = @high * TILE_SIZE
          @parts.addChild blp

        else
          tlp = new PIXI.Sprite.fromFrame('hole_topLeftSide.png')
          @parts.addChild tlp

          if fillHigh > 0
            for i in [0...fillHigh] by 1
              lp = new PIXI.Sprite.fromFrame('hole_middleLeftSide.png')
              lp.position.y = (i+1) * TILE_SIZE
              @parts.addChild lp

          blp = new PIXI.Sprite.fromFrame('hole_bottomLeftSide.png')
          blp.anchor.y = 1
          blp.position.y = @high * TILE_SIZE
          @parts.addChild blp

        # right side
        if right < halfCanvas
          trp = new PIXI.Sprite.fromFrame('hole_topRightEmpty.png')
          trp.anchor.x = 1
          trp.position.x = @wide * TILE_SIZE
          @parts.addChild trp

          if fillHigh > 0
            for i in [0...fillHigh] by 1
              rp = new PIXI.Sprite.fromFrame('hole_middleRightEmpty.png')
              rp.anchor.x = 1
              rp.position.x = @wide * TILE_SIZE
              rp.position.y = (i+1) * TILE_SIZE
              @parts.addChild rp

          brp = new PIXI.Sprite.fromFrame('hole_bottomRightEmpty.png')
          brp.anchor.x = 1
          brp.position.x = @wide * TILE_SIZE
          brp.anchor.y = 1
          brp.position.y = @high * TILE_SIZE
          @parts.addChild brp

        else
          trp = new PIXI.Sprite.fromFrame('hole_topRightSide.png')
          trp.anchor.x = 1
          trp.position.x = @wide * TILE_SIZE
          @parts.addChild trp

          if fillHigh > 0
            for i in [0...fillHigh] by 1
              rp = new PIXI.Sprite.fromFrame('hole_middleRightSide.png')
              rp.anchor.x = 1
              rp.position.x = @wide * TILE_SIZE
              rp.position.y = (i+1) * TILE_SIZE
              @parts.addChild rp

          brp = new PIXI.Sprite.fromFrame('hole_bottomRightSide.png')
          brp.anchor.x = 1
          brp.position.x = @wide * TILE_SIZE
          brp.anchor.y = 1
          brp.position.y = @high * TILE_SIZE
          @parts.addChild brp

        # Fill in the middle... if it needs it
        if fillWide > 0
          for i in [0...fillWide] by 1
            tp = new PIXI.Sprite.fromFrame('hole_topMiddle.png')
            tp.x = (i+1) * TILE_SIZE
            @parts.addChild tp

            if fillHigh > 0
              for j in [0...fillHigh] by 1
                p = new PIXI.Sprite.fromFrame('hole_middleMiddle.png')
                p.x = (i+1) * TILE_SIZE
                p.y = (j+1) * TILE_SIZE
                @parts.addChild p

            bp = new PIXI.Sprite.fromFrame('hole_bottomMiddle.png')
            bp.x = (i+1) * TILE_SIZE
            bp.anchor.y = 1
            bp.y = TILE_SIZE * @high
            @parts.addChild bp

        @parts.x = @_x
        @parts.y = @_y
        @collider.width = @wide * TILE_SIZE
        @collider.height = @high * TILE_SIZE

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


halfCanvas = 0
left = 0
right = 0
xoffset = 0
yoffset = 0
fillWide = 0
fillHigh = 0
lwj = null
rwj = null
tlp = null
blp = null
lp = null
trp = null
brp = null
rp = null
tp = null
p = null
bp = null
