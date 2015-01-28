#= require_tree ../lib/helpers
#= require_tree ../lib/geom
#= require_tree ../lib/core
#= require_tree ../lib/collider
#= require PathTestScene.coffee
#= require TilesTestScene.coffee
#= require GGJScene.coffee

class @Game extends Engine


  constructor: (canvas_id) ->
    super(canvas_id)
    @debug = true
    window.game = this
    PIXI.scaleModes.DEFAULT = PIXI.scaleModes.NEAREST

    
  init: () =>
    pathTestScene = new PathTestScene('pathTestScene', this)
    tilesTestScene = new TilesTestScene('tilesTestScene', this)
    ggjScene = new GGJScene('ggjScene', this)
    @scenes.add(pathTestScene)
    @scenes.add(tilesTestScene)
    @scenes.add(ggjScene)
    window.scene = @scenes.ready('pathTestScene')

