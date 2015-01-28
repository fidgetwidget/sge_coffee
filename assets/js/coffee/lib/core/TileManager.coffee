#= require ../tile/Chunk.coffee


class @TileManager

  scene:    undefined
  chunks:   undefined
  inScene:  undefined
  toUpdate: undefined
  typeMap:  undefined
  tiler:    undefined


  constructor: (scene) ->
    # init the chunk hash and the toUpdate list
    @scene    = scene
    @chunks   = {}
    @_chnks   = []
    @inScene  = []
    @toUpdate = []


  update: () =>
    while @toUpdate.length > 0
      u = @toUpdate.pop()
      c = @getChunk(u.x, u.y)
      c.update() unless c is undefined or c is null


  render: () =>
    # because we turn off chunks not being drawn, we need an at render time loop 
    #  to check what chunks are on screen


  makeChunk: (x, y) =>
    c = if @_chnks.length > 0 then @_chnks.pop() else new Chunk(this)
    c.chunk_x = x
    c.chunk_y = y
    c.position.x = x * (CONST.CHUNK_SIZE[0] * CONST.TILE_SIZE[0])
    c.position.y = y * (CONST.CHUNK_SIZE[1] * CONST.TILE_SIZE[1])
    @scene.addChild(c)
    @inScene.push(c)
    return c
    

  saveChunk: (x, y, to) =>
    @_ensureChunk(x, y)
    @getChunk(x, y).save(x, y, to)


  loadChunk: (x, y, from) =>
    @_ensureChunk(x, y)
    @getChunk(x, y).load(x, y, from)


  unloadChunk: (x, y) =>
    c = @getChunk(x, y)
    c.reset()
    @_chnks.push(c)
    i = @inScene.indexOf(c)
    @inScene.splice(i, 1)


  # Test for the existing of a chunk at the given x/y
  _testChunk: (x, y) =>
    return false if @chunks[x] is undefined
    return false if @chunks[x][y] is undefined
    return true


  # Make sure their is a chunk at the given x/y
  _ensureChunk: (x, y) =>
    @chunks[x] = {}                   if @chunks[x] is undefined
    @chunks[x][y] = @makeChunk(x, y)  if @chunks[x][y] is undefined


  getChunk: (x, y) =>
    return null unless @_testChunk(x, y)
    return @chunks[x][y]


  get: (world_x, world_y) =>
    chunk_x = @getChunkX(world_x)
    chunk_y = @getChunkY(world_y)
    return null unless @_testChunk(chunk_x, chunk_y)
    tile_x  = @getTileX(world_x)
    tile_y  = @getTileY(world_y)
    return @getChunk(chunk_x, chunk_y).get(tile_x, tile_y)


  set: (world_x, world_y, value, force=false) =>
    chunk_x = @getChunkX(world_x)
    chunk_y = @getChunkY(world_y)
    unless @_testChunk(chunk_x, chunk_y)
      if force then @_ensureChunk(chunk_x, chunk_y) else return null
    tile_x  = @getTileX(world_x)
    tile_y  = @getTileY(world_y)
    @toUpdate.push({ x: chunk_x, y: chunk_y })
    return @getChunk(chunk_x, chunk_y).set(tile_x, tile_y, value)


  fillChunk: (world_x, world_y, value) =>
    chunk_x = @getChunkX(world_x)
    chunk_y = @getChunkY(world_y)
    @_ensureChunk(chunk_x, chunk_y)
    @getChunk(chunk_x, chunk_y).fill(value)

  ###
  # Returns the neigbor data for the given tile (x)
  #    
  # [top, topRight, right, bottomRight, bottom, bottomLeft, left, topLeft]
  # Values are:
  # 0: no relation
  # 1: same tile type
  ###  
  getNeighborData: (chunk_x, chunk_y, tile_x, tile_y) =>
    # convert the given to world pos
    world_x = (chunk_x * CONST.CHUNK_SIZE[0]) + tile_x
    world_y = (chunk_y * CONST.CHUNK_SIZE[1]) + tile_y
    # compare tyoes and return
    type = @get(world_x, world_y)
    top         = if @get(world_x,     world_y - 1) is type then 1 else 0
    topRight    = if @get(world_x + 1, world_y - 1) is type then 1 else 0
    right       = if @get(world_x + 1, world_y)     is type then 1 else 0
    bottomRight = if @get(world_x + 1, world_y + 1) is type then 1 else 0
    bottom      = if @get(world_x,     world_y + 1) is type then 1 else 0
    bottomLeft  = if @get(world_x - 1, world_y + 1) is type then 1 else 0
    left        = if @get(world_x - 1, world_y)     is type then 1 else 0
    topLeft     = if @get(world_x - 1, world_y - 1) is type then 1 else 0
    return [top, topRight, right, bottomRight, bottom, bottomLeft, left, topLeft]


  forEachNeighbor: (chunk_x, chunk_y, tile_x, tile_y, action) =>
    # convert the given to world pos
    world_x = (chunk_x * CONST.CHUNK_SIZE[0]) + tile_x
    world_y = (chunk_y * CONST.CHUNK_SIZE[1]) + tile_y
    # compare tyoes and return
    action(world_x,     world_y - 1)
    action(world_x + 1, world_y - 1)
    action(world_x + 1, world_y    )    
    action(world_x + 1, world_y + 1)
    action(world_x,     world_y + 1)
    action(world_x - 1, world_y + 1)
    action(world_x - 1, world_y    )    
    action(world_x - 1, world_y - 1)


  updateSprite: (world_x, world_y) =>
    chunk_x = @getChunkX(world_x)
    chunk_y = @getChunkY(world_y)
    chunk = @getChunk(chunk_x, chunk_y)
    return if chunk is null
    tile_x  = @getTileX(world_x)
    tile_y  = @getTileY(world_y)
    sprite = chunk.getSprite(tile_x, tile_y)
    return if sprite is null
    data = @getNeighborData(chunk_x, chunk_y, tile_x, tile_y)
    sprite.updateNeighbors(data)


  getChunkX: (world_x) -> 
    return Math.floor(world_x / CONST.CHUNK_SIZE[0])
    
  getChunkY: (world_y) -> 
    return Math.floor(world_y / CONST.CHUNK_SIZE[1])

  getTileX: (world_x) -> 
    tile_x  = world_x % CONST.CHUNK_SIZE[0]
    tile_x += CONST.CHUNK_SIZE[0] if tile_x < 0
    return tile_x

  getTileY: (world_y) ->
    tile_y  = world_y % CONST.CHUNK_SIZE[1]
    tile_y += CONST.CHUNK_SIZE[1] if tile_y < 0
    return tile_y

