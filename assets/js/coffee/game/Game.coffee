#= require_tree ../lib/core
#= require PathTestScene.coffee
#= require TilesTestScene.coffee

class @Game extends Engine


  constructor: (canvas_id) ->
    super(canvas_id)
    window.game = this

    
  init: () =>
    pathTestScene = new PathTestScene('pathTestScene', this)
    tilesTestScene = new TilesTestScene('tilesTestScene', this)
    @scenes.add(pathTestScene)
    @scenes.add(tilesTestScene)
    @scenes.ready('tilesTestScene')
    window.scene = tilesTestScene

