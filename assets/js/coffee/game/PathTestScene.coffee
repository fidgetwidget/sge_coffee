#= require ../lib/scene/Scene.coffee 

class @PathTestScene extends Scene

  sprites: []
  path: undefined
  g: undefined
  texture: undefined


  constructor: (@name, @game) ->
    super(@name, @game)
    @type = 'PathTestScene'
    @init()
    @loadAssets()


  init: () =>
    @path = new PIXI.Path()
    @g = new PIXI.Graphics()

  # setup all of the managers
  loadAssets: () =>
    @texture = PIXI.Texture.fromImage("img/test.png")


  load: () =>
    @game.stage.addChild(this)
    @addChild(@g)
    @isReady = true


  unload: () =>
    @game.stage.removeChild(this)
    @removeChild(@g)
    @isReady = false


  # Update stuff
  update: (delta) =>
    return unless @isReady
    if @game.input.current[@game.input.KEY['B']] and @sprites.length < 1000
      @sprites.push(@_makeSprite())
    
    if @game.input.mouseDown
      points = @path.points
      pos = @game.input.offsetPosition(@game.canvas)
      if points.length > 0
        last_point = points[@path.points.length-1]
        distanceSquared = Math.distanceBetweenSquared(last_point.x, last_point.y, pos.x, pos.y)
        if distanceSquared > Math.pow(5, 2)
          @path.addPoint pos.x, pos.y
      else
        @path.addPoint pos.x, pos.y
    else
      @path.clear()

    for key, sprite of @sprites
      sprite.rotation += (0.5 * (delta/1000))


  # The Render part of the loop
  render: () =>
    return unless @isReady
    @g.clear()
    if @path.points.length >= 2
      @g.lineStyle(1, 'black')
      @path.drawPath @g
    @game.text.innerText = "#{@path.points.length}"
    
    for s in @sprites
      b = s.getBounds()
      @g.lineStyle(1, 'black')
      @g.drawRect(b.x, b.y, b.width, b.height)


  # TEMP
  _makeSprite: () =>
    s = new PIXI.Sprite(@texture)
    s.anchor.x = 0.5
    s.anchor.y = 0.5
    s.position.x = Random.intBetween(20, @width - 20)
    s.position.y = Random.intBetween(20, @height - 20)
    @addChild(s)
    return s
