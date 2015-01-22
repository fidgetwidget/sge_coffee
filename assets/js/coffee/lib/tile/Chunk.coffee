#= require AutoTileSprite.coffee


class @Chunk extends PIXI.DisplayObjectContainer

  chunk_x: 0
  chunk_y: 0
  manager:  undefined
  tiles:    {}
  tile_sprites:  {}
  toUpdate: []
  clean:    true
  onScreen: false
  

  constructor: (tileManager) ->
    super()
    @manager = tileManager
    @reset()
    @initTiles()
    @width = CONST.CHUNK_SIZE[0] * CONST.TILE_SIZE[0]
    @height = CONST.CHUNK_SIZE[1] * CONST.TILE_SIZE[1]


  initTiles: () =>
    for xx in [0...CONST.CHUNK_SIZE[0]]
      for yy in [0...CONST.CHUNK_SIZE[1]]
        @_ensureTile(xx, yy)


  update: (delta) =>
    # update the toUpdate tiles
    while @toUpdate.length > 0
      u = @toUpdate.pop()
      tile = @get(u.x, u.y)
      continue if tile is null
      @updateNeighbors(u.x, u.y)


  updateNeighbors: (tile_x, tile_y) =>
    neighborData = @manager.getNeighborData(@chunk_x, @chunk_y, tile_x, tile_y)
    sprite = @getSprite(tile_x, tile_y)
    sprite.updateNeighbors(neighborData)
    @manager.forEachNeighbor(@chunk_x, @chunk_y, tile_x, tile_y, @manager.updateSprite)


  render: () =>
    # TODO: test if chunk is in view, and if not, mark self as not visible 
    #   this way we can pause any animations on the tiles 



  save: (to) =>
    # save to the destination given


  load: (from) =>
    # load from the given source


  set: (x, y, value) =>
    @_ensureTile(x, y)
    @toUpdate.push({x:x, y:y}) unless @tiles[x][y] is value
    if value is null
      if @_testSprite(x, y)
        @removeChild @tile_sprites[x][y]
        delete @tile_sprites[x][y]
    else
      if @_testSprite(x, y)
        unless @tiles[x][y] is value
          typeName = @manager.typeMap[value]
          @tile_sprites[x][y].changeType(typeName)

      else
        @_ensureSprite(x, y)
        @tile_sprites[x][y] = @makeSprite(x, y, value)

    return @tiles[x][y] = value 

  fill: (value) =>
    for xx in [0...CONST.CHUNK_SIZE[0]]
      for yy in [0...CONST.CHUNK_SIZE[1]]
        @set(xx, yy, value)


  get: (x, y) =>
    return null unless @_testTile(x, y)
    return @tiles[x][y]


  getSprite: (x, y) =>
    return null unless @_testSprite(x, y)
    return @tile_sprites[x][y]


  makeSprite: (x, y, value) =>
    return null if value is null
    typeName = @manager.typeMap[value]
    sprite = new AutoTileSprite(typeName)
    sprite.position.x = x * CONST.TILE_SIZE[0]
    sprite.position.y = y * CONST.TILE_SIZE[1]
    @_ensureSprite(x, y)
    @tile_sprites[x][y] = sprite
    @addChild(sprite)
    return sprite


  getBounds: (matrix) ->
    bounds = @_bounds 
    bounds.x = @position.x
    bounds.y = @position.y
    bounds.width = CONST.CHUNK_SIZE[0] * CONST.TILE_SIZE[0]
    bounds.height = CONST.CHUNK_SIZE[1] * CONST.TILE_SIZE[1]
    @currentBounds = bounds
    return bounds
    

  _testTile: (x, y) ->
    return false if @tiles[x] is undefined
    return false if @tiles[x][y] is undefined
    return true

  _ensureTile: (x, y) =>
    return if x > CONST.CHUNK_SIZE[0] or x < 0
    return if y > CONST.CHUNK_SIZE[1] or y < 0
    @tiles[x] = {}      if @tiles[x] is undefined
    @tiles[x][y] = null if @tiles[x][y] is undefined


  _testSprite: (x, y) ->
    return false if @tile_sprites[x] is undefined
    return false if @tile_sprites[x][y] is undefined
    return true

  _ensureSprite: (x, y) =>
    @tile_sprites[x] = {}      if @tile_sprites[x] is undefined
    @tile_sprites[x][y] = null if @tile_sprites[x][y] is undefined


  reset: () =>
    # TODO: do a better job of recycling the object and array...
    @chunk_x  = Number.Nan
    @chunk_y  = Number.Nan
    @tiles    = {}
    @tile_sprites  = {}
    @clean    = true
    @onScreen = false
    @toUpdate.pop() while @toUpdate.length > 0

    return @

