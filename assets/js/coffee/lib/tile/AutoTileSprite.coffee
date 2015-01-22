#= require ../core/Const.coffee

### 
# 
# A Composit tile sprite that is neighbor aware
# 
### 
class @AutoTileSprite extends PIXI.DisplayObjectContainer

  # :: DisplayObject 
  # :: DisplayObjectContainer

  tileTypeName: undefined
  # child sprites
  a: undefined # top left
  b: undefined # top right
  c: undefined # bottom left
  d: undefined # bottom right

  # 
  # Constructor
  constructor: (tileTypeName) ->
    super()
    @tileTypeName = tileTypeName

    @a = PIXI.Sprite.fromFrame("#{@tileTypeName}-a4")
    @b = PIXI.Sprite.fromFrame("#{@tileTypeName}-b4")
    @c = PIXI.Sprite.fromFrame("#{@tileTypeName}-c4")
    @d = PIXI.Sprite.fromFrame("#{@tileTypeName}-d4")

    @b.position.x = CONST.TILE_PART_SIZE[0]
    @c.position.y = CONST.TILE_PART_SIZE[1]
    @d.position.x = CONST.TILE_PART_SIZE[0]
    @d.position.y = CONST.TILE_PART_SIZE[1]

    @addChild(@a)
    @addChild(@b)
    @addChild(@c)
    @addChild(@d)


  changeType: (tileTypeName) =>
    @tileTypeName = tileTypeName
    @a.setTexture(PIXI.Texture.fromFrame("#{@tileTypeName}-a4"))
    @b.setTexture(PIXI.Texture.fromFrame("#{@tileTypeName}-b4"))
    @c.setTexture(PIXI.Texture.fromFrame("#{@tileTypeName}-c4"))
    @d.setTexture(PIXI.Texture.fromFrame("#{@tileTypeName}-d4"))


  # 
  # Set the child sprites based on the neighborData
  updateNeighbors: (neighborData) ->
    textures = AutoTiler.getTextures(@tileTypeName, neighborData)
    @a.setTexture(textures[0])
    @b.setTexture(textures[1])
    @c.setTexture(textures[2])
    @d.setTexture(textures[3])


# Object.defineProperty PIXI.AutoTileSprite::, "x",
#   get: ->
#     @position.x

#   set: (value) ->
#     @position.x = value
#     @a.x = value
#     @b.x = value + TILE_PART_SIZE[0]
#     @c.x = value
#     @d.x = value + TILE_PART_SIZE[0]
#     return

# Object.defineProperty PIXI.AutoTileSprite::, "y",
#   get: ->
#     @position.y

#   set: (value) ->
#     @position.y = value
#     @a.y = value
#     @b.y = value
#     @c.y = value + TILE_PART_SIZE[0]
#     @d.y = value + TILE_PART_SIZE[0]
#     return
