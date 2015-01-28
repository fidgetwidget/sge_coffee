
TILE_SIZE     = 16
OFFSIDE_WIDTH = TILE_SIZE * 3
TOP_HEIGHT    = TILE_SIZE * 4
MIN_HIGH      = 24



class @GGJRoom extends Entity

  parts: undefined
  high: MIN_HIGH
  colliders: undefined
  canvasWidth: 0
  isFirstRoom: false
  baseInit: false
  background: undefined
  walls: undefined

  constructor: (name, game, scene) ->
    super(name, game, scene)
    @type = 'GGJRoom'


  init: () =>
    @canvasWidth = @game.canvas.width
    @parts       = { wall: [], hole: [] }
    @colliders   = { wall: [], hole: [] }
    @background  = new PIXI.DisplayObjectContainer()
    @walls       = new PIXI.DisplayObjectContainer()
    @sprites     = new PIXI.DisplayObjectContainer()


  ready: () =>
    switch @name
      when 'empty'
        @high = 6 * Random.intBetween(1, 3)
      when 'wall'
        @high = 6
      when 'hole'
        @high = 6


    @initBase() unless @baseInit
    @scene.background.addChild(@background)
    @scene.background.addChild(@walls)
    @scene.stage.addChild(@sprites)

    switch @name

      when 'wall'
        wide = 2 * Random.intBetween(1, 5)
        max = ((@canvasWidth / TILE_SIZE) - wide - 10)
        left = (2 * Random.intBetween(0, (max/2) + 1)) + 5

        wall = new GGJPart('wall', @game, @scene, this)
        wall.wide = wide
        wall.x = left * TILE_SIZE
        wall.ready()
        @parts['wall'].push(wall)
        @colliders['wall'].push(wall.collider)
        @sprites.addChild(wall.parts)

      when 'hole'
        wide = 2 * Random.intBetween(1, 4)
        high = Random.intBetween(2, 5)
        max = ((@canvasWidth / TILE_SIZE) - wide - 10)
        left = (2 * Random.intBetween(0, (max/2) + 1)) + 5

        hole = new GGJPart('hole', @game, @scene, this)
        hole.wide = wide
        hole.high = high
        hole.x = left * TILE_SIZE
        hole.ready()
        @parts['hole'].push(hole)
        @colliders['hole'].push(hole.collider)
        @background.addChild(hole.parts)

    @isReady = true


  initBase: () =>
    lwt = PIXI.TextureCache['leftWallPiece.png']
    rwt = PIXI.TextureCache['rightWallPiece.png']
    bgt = PIXI.TextureCache['outsideBackground.png']
    ft = PIXI.TextureCache['tile.png']

    lbg = new PIXI.TilingSprite(bgt, OFFSIDE_WIDTH, @height)
    rbg = new PIXI.TilingSprite(bgt, OFFSIDE_WIDTH, @height)
    rbg.anchor.x = 1
    rbg.position.x = @canvasWidth
    floor = new PIXI.TilingSprite(ft, @canvasWidth - (OFFSIDE_WIDTH * 2), @height)
    floor.x = OFFSIDE_WIDTH
    @background.addChild(floor)
    @background.addChild(lbg)
    @background.addChild(rbg)

    if @isFirstRoom
      lw = new PIXI.TilingSprite(lwt, lwt.width, @height - TOP_HEIGHT)
      rw = new PIXI.TilingSprite(rwt, rwt.width, @height - TOP_HEIGHT)
      lw.position.y = TOP_HEIGHT
      rw.position.y = TOP_HEIGHT
    else
      lw = new PIXI.TilingSprite(lwt, lwt.width, @height)
      rw = new PIXI.TilingSprite(rwt, rwt.width, @height)

    lw.position.x = 48
    rw.anchor.x = 1
    rw.position.x = @canvasWidth - 48

    @parts['leftWallPiece'] = lw
    @parts['rightWallPiece'] = rw
    @walls.addChild(lw)
    @walls.addChild(rw)

    if @isFirstRoom
      topPart = new PIXI.Sprite.fromFrame('templeTop.png')
      topPart.anchor.x = 0.5
      topPart.position.y = 0
      topPart.position.x = @canvasWidth * 0.5
      @parts['templeTop'] = topPart
      @walls.addChild(topPart)

    sideWidth = OFFSIDE_WIDTH + rwt.width
    xoffset =   (@canvasWidth * 0.5) - (sideWidth * 0.5)
    lCollider = BoxCollider.fromValues(this, -xoffset , 0, sideWidth, @height) 
    rCollider = BoxCollider.fromValues(this, xoffset, 0, sideWidth, @height) 
    @colliders.wall.push(lCollider)
    @colliders.wall.push(rCollider)
    @baseInit = true


  unload: () =>
    while @parts.wall.length > 0
      @parts.wall.pop()
    while @parts.hole.length > 0
      @parts.hole.pop()

    while @colliders.wall.length > 0
      @colliders.wall.pop()
    while @colliders.hole.length > 0
      @colliders.hole.pop()

    @background.removeChildren()
    @walls.removeChildren()
    @sprites.removeChildren()

    @scene.background.removeChild(@background)
    @scene.background.removeChild(@walls)
    @scene.stage.removeChild(@sprites)

    @resetValues()

    @isReady = false


  update: (delta) =>
    # Do some state changing stuff here?


  render: () =>
    @background.x = @x
    @background.y = @y
    @walls.x = @x
    @walls.y = @y
    @sprites.x = @x
    @sprites.y = @y


  drawBounds: (graphics) =>
    for wall in @colliders.wall
      bounds = if wall instanceof AABB then wall else wall.getAABB()
      graphics.drawRect(bounds.left, bounds.top, bounds.width, bounds.height)

    for hole in @colliders.hole
      bounds = if hole instanceof AABB then hole else hole.getAABB()
      graphics.drawRect(bounds.left, bounds.top, bounds.width, bounds.height)


  clone: () =>
    clone = new GGJRoom(@name, @game, @scene)
    return clone


  collisionTest: (bounds) =>
    return unless bounds #early exit for a null bounds check
    for wall in @colliders.wall
      if wall.testAABB(bounds)
        return true

    for hole in @colliders.hole
      if hole.testAABB(bounds)
        return true

    return false


  resolveCollision: (entity) =>
    bounds = entity.getAABB()
    return unless bounds #early exit for a null bounds check

    for wall in @colliders.wall
      r = wall.collideAABB(bounds)
      if r isnt false
        if r.px isnt 0
          entity.x -= r.px
        else
          entity.y -= r.py

    for hole in @colliders.hole
      r = hole.collideAABB(bounds)
      if r isnt false
        # give the player a little push out of the hole...
        if r.px isnt 0
          entity.x -= r.px * 0.1
        else
          entity.y -= r.py * 0.1
        continue unless Math.abs(r.px) > 8 or Math.abs(r.py) > 8
        entity.die()


  _getWidth: () =>
    return 320

  _getHeight: () =>
    return @high * 16

  _setHeight: (value) =>
    return @high = value / 16

    
