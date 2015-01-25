#= require_tree ../lib/helpers
#= require_tree ../lib/geom
#= require_tree ../lib/core
#= require PathTestScene.coffee
#= require TilesTestScene.coffee
#= require GGJScene.coffee

class @Game extends Engine


  constructor: (canvas_id) ->
    super(canvas_id)
    window.game = this

    
  init: () =>
    # pathTestScene = new PathTestScene('pathTestScene', this)
    # tilesTestScene = new TilesTestScene('tilesTestScene', this)
    ggjScene = new GGJScene('ggjScene', this)
    # @scenes.add(pathTestScene)
    # @scenes.add(tilesTestScene)
    @scenes.add(ggjScene)
    @scenes.ready('ggjScene')
    window.scene = ggjScene

