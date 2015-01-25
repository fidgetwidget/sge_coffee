OFFSIDE_WIDTH = 16 * 3
TOP_HEIGHT = 16 * 4
MIN_HEIGHT = 32 * 24


class @GGJRoom extends Entity

  parts: undefined
  height: MIN_HEIGHT
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
    @sprite = new PIXI.DisplayObjectContainer()


  initBase: () =>
    lwt = PIXI.TextureCache['leftWallPiece.png']
    rwt = PIXI.TextureCache['rightWallPiece.png']
    bgt = PIXI.TextureCache['outsideBackground.png']

    lbg = new PIXI.TilingSprite(bgt, OFFSIDE_WIDTH, @height)
    rbg = new PIXI.TilingSprite(bgt, OFFSIDE_WIDTH, @height)
    rbg.anchor.x = 1
    rbg.position.x = @canvasWidth
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

    lCollider = AABB.fromValues(0, 0, OFFSIDE_WIDTH + lwt.width, @height)
    sideWidth = OFFSIDE_WIDTH + rwt.width
    rCollider = AABB.fromValues(@canvasWidth - sideWidth, 0, sideWidth, @height)

    @colliders.wall.push(lCollider)
    @colliders.wall.push(rCollider)
    @baseInit = true


  ready: () =>
    switch @name
      when 'empty'
        @height = 32 * 6
      when 'leftSideWall'
        @height = 32 * 6
      when 'rightSideWall'
        @height = 32 * 6
      when 'leftHole'
        @height = 32 * 6
      when 'rightHole'
        @height = 32 * 6

    @initBase() unless @baseInit
    @scene.background.addChild(@background)
    @scene.background.addChild(@walls)
    @scene.stage.addChild(@sprite)

    switch @name

      when 'leftSideWall'
        wide = Random.intBetween(2, 4)
        wall = new GGJPart('wall', @game, @scene)
        wall.wide = wide
        wall.x = (16 * 5)
        wall.ready()
        @parts['wall'] = wall
        @colliders['wall'].push(wall.collider)
        @sprite.addChild(wall.sprite)

      when 'rightSideWall'
        wide = Random.intBetween(2, 4)
        wall = new GGJPart('wall', @game, @scene)
        wall.wide = wide
        wall.x = @game.canvas.width - (16 * 5) - (wide * 16)
        wall.ready()
        @parts['wall'] = wall
        @colliders['wall'].push(wall.collider)
        @sprite.addChild(wall.sprite)

      when 'leftHole'
        true

      when 'rightHole'
        true

    @isReady = true


  unload: () =>
    @scene.background.removeChild(@background)
    @scene.background.removeChild(@walls)
    @isReady = false


  update: (delta) =>

    # Do some state changing stuff here?


  render: () =>
    @background.position.x = @_x
    @background.position.y = @_y
    @walls.position.x = @_x
    @walls.position.y = @_y
    # change animation if state changed


  clone: () =>
    clone = new GGJRoom(@name, @game, @scene)
    clone.height = @height
    return clone


  collisionTest: (bounds) =>
    return unless bounds #early exit for a null bounds check
    for wall in @colliders.wall
      if wall.testAABB(bounds)
        return true

    # TODO: also test the kill

    return false


  resolveCollision: (entity) =>
    bounds = entity.getBounds()
    return unless bounds #early exit for a null bounds check

    for wall in @colliders.wall
      r = wall.collideAABB(bounds)
      if r isnt false
        if r.px isnt 0
          entity.x -= r.px
        else
          entity.x -= r.py

