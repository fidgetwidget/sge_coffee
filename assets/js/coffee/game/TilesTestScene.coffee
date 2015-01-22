#= require ../lib/scene/Scene.coffee 
#= require ../lib/tile/AutoTiler.coffee 

class @TilesTestScene extends Scene

  tiles: undefined
  g: undefined
  showChunkLines: false
  current_tile_index: 1
  moveSpeed: 0.1


  constructor: (@name, @game) ->
    super(@name, @game)
    @type = 'TilesTestScene'
    @init()
    @loadAssets()


  init: () =>
    @tiles = new TileManager(this)
    @g = new PIXI.Graphics()


  # setup all of the managers
  loadAssets: () =>
    texture = PIXI.Texture.fromImage("img/tiles.png", false, PIXI.scaleModes.NEAREST)
    tiler = new AutoTiler(texture)
    tiler.cachePartFrames('dirt',   0,                        0)
    tiler.cachePartFrames('grass',  CONST.TILE_SET_SIZE[0],   0)
    tiler.cachePartFrames('sand',   CONST.TILE_SET_SIZE[0]*2, 0)
    tiler.cachePartFrames('dust',   CONST.TILE_SET_SIZE[0]*3, 0)
    tiler.cachePartFrames('mud',    CONST.TILE_SET_SIZE[0]*4, 0)
    tiler.cachePartFrames('wall',   0,                        CONST.TILE_SET_SIZE[1])
    tiler.cachePartFrames('wall2',  CONST.TILE_SET_SIZE[0]*5, CONST.TILE_SET_SIZE[1])
    tiler.cachePartFrames('wall3',  CONST.TILE_SET_SIZE[0]*6, CONST.TILE_SET_SIZE[1])
    tiler.cachePartFrames('hole',   0,                        CONST.TILE_SET_SIZE[1]*2)
    tiler.cachePartFrames('water',  CONST.TILE_SET_SIZE[0]*4, CONST.TILE_SET_SIZE[1]*2)
    
    @tiles.tiler = tiler
    @tiles.typeMap = {
      0: 'dirt'
      1: 'grass'
      2: 'sand'
      3: 'mud'
      4: 'water'
      5: 'hole'
      6: 'wall'
    }


  load: () =>
    @game.stage.addChild(this)
    @addChild(@g)
    @ready = true
    


  unload: () =>
    @game.stage.removeChild(this)
    @removeChild(@g)
    @ready = false
    


  # Update stuff
  update: (delta) =>
    return unless @ready
    pos = @game.input.offsetPosition(@game.canvas)
    world_x = Math.floor((pos.x - @position.x) / (CONST.TILE_SIZE[0] * @scale.x))
    world_y = Math.floor((pos.y - @position.y) / (CONST.TILE_SIZE[1] * @scale.y))
    chunk_x = Math.floor(world_x / CONST.CHUNK_SIZE[0])
    chunk_y = Math.floor(world_y / CONST.CHUNK_SIZE[1])
    tile_x  = world_x % CONST.CHUNK_SIZE[0]
    tile_y  = world_y % CONST.CHUNK_SIZE[1]

    @game.text.innerText = "wx:#{world_x} wy:#{world_y} cx:#{chunk_x} cy:#{chunk_y} tx:#{tile_x} ty:#{tile_y}"
    @tiles.update(delta)

    if @game.input.mouseDown
      @tiles.set(world_x, world_y, @current_tile_index, true)

    if @game.input.current[@game.input.KEY['F']]
      @tiles.fillChunk(world_x, world_y, @current_tile_index, true)

    if @game.input.current[@game.input.KEY['0']]
      @current_tile_index = 0
    else if @game.input.current[@game.input.KEY['1']]
      @current_tile_index = 1
    else if @game.input.current[@game.input.KEY['2']]
      @current_tile_index = 2
    else if @game.input.current[@game.input.KEY['3']]
      @current_tile_index = 3
    else if @game.input.current[@game.input.KEY['4']]
      @current_tile_index = 4
    else if @game.input.current[@game.input.KEY['5']]
      @current_tile_index = 5
    else if @game.input.current[@game.input.KEY['6']]
      @current_tile_index = 6

    if @game.input.current[@game.input.KEY['ARROW_UP']]
      @position.y += @scale.y * delta * @moveSpeed
    else if @game.input.current[@game.input.KEY['ARROW_DOWN']]
      @position.y -= @scale.y * delta * @moveSpeed
    if @game.input.current[@game.input.KEY['ARROW_LEFT']]
      @position.x += @scale.x * delta * @moveSpeed
    else if @game.input.current[@game.input.KEY['ARROW_RIGHT']]
      @position.x -= @scale.x * delta * @moveSpeed

    @position.x = Math.floor(@position.x)
    @position.y = Math.floor(@position.y)

    if @game.input.release[@game.input.KEY['LEFT_SQUARE_BRACKET']]
      @scale.x -= 0.25 unless @scale.x is 0.25
      @scale.y -= 0.25 unless @scale.y is 0.25
    else if @game.input.release[@game.input.KEY['RIGHT_SQUARE_BRACKET']]
      @scale.x += 0.25 unless @scale.x is 3
      @scale.y += 0.25 unless @scale.y is 3


  # The Render part of the loop
  render: () =>
    return unless @ready
    if @showChunkLines
      @g.clear()
      @g.lineStyle(1, 'black')
      for xkey of @tiles.chunks
        for ykey of @tiles.chunks[xkey]
          chunk = @tiles.chunks[xkey][ykey]
          @g.drawShape(chunk.getBounds())

