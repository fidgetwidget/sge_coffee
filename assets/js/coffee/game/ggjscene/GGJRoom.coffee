OFFSIDE_WIDTH = 16 * 3
TOP_HEIGHT = 16 * 4
MIN_HIGH = 24


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
    @parts = {}
    @colliders = {
      wall: []
      kill: []
    }
    @background = new PIXI.DisplayObjectContainer()
    @walls = new PIXI.DisplayObjectContainer()
    @sprites = new PIXI.DisplayObjectContainer()


  ready: () =>
    switch @name
      when 'empty'
        @high = 6 * Random.intBetween(1, 3)
      when 'leftSideWall'
        @high = 6
      when 'rightSideWall'
        @high = 6
      when 'middleWall'
        @high = 6
      when 'leftHole'
        @high = 6
      when 'rightHole'
        @high = 6

    @initBase() unless @baseInit
    @scene.background.addChild(@background)
    @scene.background.addChild(@walls)
    @scene.stage.addChild(@sprites)

    switch @name

      when 'leftSideWall'
        wide = 2 * Random.intBetween(1, 3)
        wall = new GGJPart('wall', @game, @scene, this)
        wall.wide = wide
        wall.x = (@canvasWidth * 0.5) - (16 * 5)
        wall.ready()
        @parts['wall'] = wall
        @colliders['wall'].push(wall.collider)
        @sprites.addChild(wall.parts)

      when 'rightSideWall'
        wide = 2 * Random.intBetween(1, 3)
        wall = new GGJPart('wall', @game, @scene, this)
        wall.wide = wide
        wall.x = (@canvasWidth * 0.5) + (16 * 5) - (wide * 16)
        wall.ready()
        @parts['wall'] = wall
        @colliders['wall'].push(wall.collider)
        @sprites.addChild(wall.parts)

      when 'middleWall'
        wide = 2 * Random.intBetween(1, 3)
        wall = new GGJPart('wall', @game, @scene, this)
        wall.wide = wide
        wall.x = (@canvasWidth * 0.5) - (16 * wide * 0.5)
        wall.ready()
        @parts['wall'] = wall
        @colliders['wall'].push(wall.collider)
        @sprites.addChild(wall.parts)

      when 'leftHole'
        true

      when 'rightHole'
        true

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
    @scene.background.removeChild(@background)
    @scene.background.removeChild(@walls)
    @scene.stage.removeChild(@sprites)
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


  clone: () =>
    clone = new GGJRoom(@name, @game, @scene)
    return clone


  collisionTest: (bounds) =>
    return unless bounds #early exit for a null bounds check
    for wall in @colliders.wall
      if wall.testAABB(bounds)
        return true

    # TODO: also test the kill

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


  _getWidth: () =>
    return 320

  _getHeight: () =>
    return @high * 16

  _setHeight: (value) =>
    return @high = value / 16

    
