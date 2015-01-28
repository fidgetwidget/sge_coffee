
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
  midground: undefined
  foreground: undefined

  constructor: (name, game, scene) ->
    super(name, game, scene)
    @type = 'GGJRoom'


  init: () =>
    @canvasWidth = @game.canvas.width
    @parts       = { wall: [], hole: [] }
    @colliders   = { wall: [], hole: [] }

    @background  = new PIXI.DisplayObjectContainer()
    @midground   = new PIXI.DisplayObjectContainer()
    @foreground  = new PIXI.DisplayObjectContainer()


  ready: () =>

    @scene.background.addChild(@background)
    @scene.midground.addChild(@midground)
    @scene.foreground.addChild(@foreground)

    @initBase() unless @baseInit

    switch @name
      when 'empty'
        @high = 6 * Random.intBetween(1, 3)
      when 'wall'
        @high = 6
      when 'hole'
        @high = 6

    switch @name

      when 'wall'
        wide = 2 * Random.intBetween(1, 5)
        max = ((@canvasWidth / TILE_SIZE) - wide - 10)
        left = (2 * Random.intBetween(0, (max/2) + 1)) + 5

        wall = new GGJPart('wall', @game, @scene, this)
        wall.wide = wide
        wall.x = left * TILE_SIZE
        # wall.ready()
        @parts['wall'].push(wall)
        @colliders['wall'].push(wall.collider)
        wall.ready()

      when 'hole'
        wide = 2 * Random.intBetween(1, 4)
        high = Random.intBetween(2, 5)
        max = ((@canvasWidth / TILE_SIZE) - wide - 10)
        left = (2 * Random.intBetween(0, (max/2) + 1)) + 5

        hole = new GGJPart('hole', @game, @scene, this)
        hole.wide = wide
        hole.high = high
        hole.x = left * TILE_SIZE
        # hole.ready()
        @parts['hole'].push(hole)
        @colliders['hole'].push(hole.collider)
        hole.ready()

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
    @background.addChild(lw)
    @background.addChild(rw)

    if @isFirstRoom
      topPart = new PIXI.Sprite.fromFrame('templeTop.png')
      topPart.anchor.x = 0.5
      topPart.position.y = 0
      topPart.position.x = @canvasWidth * 0.5
      @parts['templeTop'] = topPart
      @background.addChild(topPart)

    sideWidth = OFFSIDE_WIDTH + rwt.width
    xoffset =   (@canvasWidth * 0.5) - (sideWidth * 0.5)
    lCollider = BoxCollider.fromValues(this, -xoffset , 0, sideWidth, @height) 
    rCollider = BoxCollider.fromValues(this, xoffset, 0, sideWidth, @height) 
    @colliders.wall.push(lCollider)
    @colliders.wall.push(rCollider)
    @baseInit = true


  unload: () =>
    while @parts.wall.length > 0
      @parts.wall.pop().unload()
    while @parts.hole.length > 0
      @parts.hole.pop().unload()

    while @colliders.wall.length > 0
      @colliders.wall.pop().unload()
    while @colliders.hole.length > 0
      @colliders.hole.pop().unload()

    @background.removeChildren()
    @midground.removeChildren()
    @foreground.removeChildren()

    @scene.background.removeChild(@background)
    @scene.midground.removeChild(@midground)
    @scene.foreground.removeChild(@foreground)

    @resetValues()

    @isReady = false


  update: () =>
    for wall in @parts.wall
      wall.update()
    for hole in @parts.hole
      hole.update()
    # Do some state changing stuff here?


  render: () =>
    @background.x = @x
    @background.y = @y
    @midground.x = @x
    @midground.y = @y
    @foreground.x = @x
    @foreground.y = @y


  drawBounds: (graphics) =>
    for wall in @colliders.wall
      bounds = if wall instanceof AABB then wall else wall.aabb
      graphics.drawRect(bounds.left, bounds.top, bounds.width, bounds.height)

    for hole in @colliders.hole
      bounds = if hole instanceof AABB then hole else hole.aabb
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


  doCollision: (entity, results) =>
    bounds = entity.aabb
    return unless bounds #early exit for a null bounds check
    results = results || []
    for wall in @colliders.wall
      r = wall.collideAABB(bounds)
      if r isnt false
        r.type = 'wall'
        results.push(r)
    for hole in @colliders.hole
      r = hole.collideAABB(bounds)
      if r isnt false
        r.type = 'hole'
        results.push(r)
    return results.length > 0


  _getWidth: () =>
    return 320

  _getHeight: () =>
    return @high * TILE_SIZE

  _setHeight: (value) =>
    return @high = value / TILE_SIZE

    
