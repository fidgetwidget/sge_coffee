
###
# This is a system for drawing tiles with neighbor awareness, using tile art in the style
#  of RPG Maker VX - 2 tiles wide, and 3 tiles tall. 
#   ╔═╦═╗  
#   ║A║B║  
#   ╠═╩═╣
#   ║C  ║  
#   ║   ║  
#   ╚═══╝ 
# The tiles are made up of 4 pieces each, and using the parts, the missing neighbor state 
#  tiles are generated for you.
# Refs: 
#  http://blog.rpgmakerweb.com/tutorials/anatomy-of-an-autotile/
#  http://blog42701.blog42.fc2.com/blog-entry-73.html
#  http://tkool.jp/products/rpgvx/material.html
#  http://personal.boristhebrave.com/tutorials/tileset-roundup
###
class @AutoTiler

  # 
  # 
  constructor: (texture) ->
    @baseTexture = if texture instanceof PIXI.Texture then texture.baseTexture else texture
    @parts = {}

  # 
  #
  cachePartFrames: (tileTypeName, offsetX=0, offsetY=0) ->
    tileTypeParts = @parts['tileTypeName'] = []
    texture = new PIXI.Texture(@baseTexture, {
        x: offsetX,
        y: offsetY,
        width:  CONST.TILE_PART_SIZE[0],
        height: CONST.TILE_PART_SIZE[1]
      })
    PIXI.TextureCache["#{tileTypeName}"] = texture

    for index in [1..6] by 1
      for n in [0..4] by 1
        a   = CONST.TILE_PART_LETTER[n]
        x   = CONST.TILE_OFFSET[0][index]
        y   = CONST.TILE_OFFSET[1][index]
        xx  = CONST.TILE_PART_OFFSET[0][n]
        yy  = CONST.TILE_PART_OFFSET[1][n]
        texture = new PIXI.Texture(@baseTexture, {
            x: (x * CONST.TILE_SIZE[0]) + (xx * CONST.TILE_PART_SIZE[0]) + offsetX,
            y: (y * CONST.TILE_SIZE[1]) + (yy * CONST.TILE_PART_SIZE[1]) + offsetY,
            width:  CONST.TILE_PART_SIZE[0],
            height: CONST.TILE_PART_SIZE[1]
          })
        partName = "#{a}#{index - 1}"
        tileTypeParts.push(texture)
        PIXI.TextureCache["#{tileTypeName}-#{partName}"] = texture

  ### 
  # Neighbor data should look like this:
  # [top, topRight, right, bottomRight, bottom, leftBottom, left, topLeft]
  # values 0 is no match, 1 is a match
  ### 
  @getPartsData: (neighborData, results) ->
    results = results || [] # [ topLeft, topRight, bottomLeft, bottomRight ] part indexes
    # TOP LEFT
    results[0] = neighborData[6] + (neighborData[0] * 2) # left + 2*top
    results[0] = 4 if neighborData[0] is 1 and neighborData[6] is 1 and neighborData[7]
    # TOP RIGHT
    results[1] = neighborData[2] + (neighborData[0] * 2) # right + 2*top
    results[1] = 4 if neighborData[0] is 1 and neighborData[1] is 1 and neighborData[2]
    # BOTTOM LEFT
    results[2] = neighborData[6] + (neighborData[4] * 2) # left + 2*bottom
    results[2] = 4 if neighborData[4] is 1 and neighborData[5] is 1 and neighborData[6]
    # BOTTOM RIGHT
    results[3] = neighborData[2] + (neighborData[4] * 2) # right + 2*bottom
    results[3] = 4 if neighborData[2] is 1 and neighborData[3] is 1 and neighborData[4]
    return results


  @getTextures: (tileTypeName, neighborData) ->
    @partsData = [] if @partsData is undefined
    @getPartsData(neighborData, @partsData)
    return [
      PIXI.TextureCache["#{tileTypeName}-a#{CONST.TILE_PART_INDEX[0][@partsData[0]]}"]
      PIXI.TextureCache["#{tileTypeName}-b#{CONST.TILE_PART_INDEX[1][@partsData[1]]}"]
      PIXI.TextureCache["#{tileTypeName}-c#{CONST.TILE_PART_INDEX[2][@partsData[2]]}"]
      PIXI.TextureCache["#{tileTypeName}-d#{CONST.TILE_PART_INDEX[3][@partsData[3]]}"]
    ]
