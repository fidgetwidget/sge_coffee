
class @Scene extends PIXI.DisplayObjectContainer

  # :: DisplayObject 
  # :: DisplayObjectContainer
  name: ''
  type: 'Scene'
  game: undefined
  assetsLoaded: false
  isReady: false
  
  # Sprite Groups for drawing position
  background: undefined
  stage: undefined
  foreground: undefined



  constructor: (@name, @game) ->
    super()
    @_width = @game.canvas.width
    @_height = @game.canvas.height
    # create the scene

  init: () =>
    # this is what is called when the scene is added to the game

  loadAssets: () =>
    # load your assets here


  load: () =>
    # this is what is called when the scene is made ready to display

  unload: () =>
    # this is what is called when the scene is removed from display



  update: (delta) =>
    # update the scene...


  render: () =>
    # render the scene...


  getBounds: (matrix) =>
    # TODO: use the matrix to adjust the bounds based on it
    matrix = matrix
    @_bounds.x = @x
    @_bounds.y = @y
    @_bounds.width = @_width
    @_bounds.height = @_height

    return @_bounds
