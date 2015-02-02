#= require ../lib/scene/Scene.coffee 
#= require_tree /ggjscene

STATES            = { PAUSE: 0, RUN: 1, RESET: 2 }
BOOST_THREASHOLD  = 180 * 180
MOVE_THREASHOLD   = 30 * 30
BOOST_SPEED       = 96 / 30
INIT_SPEED        = 80 / 30
MOVE_SPEED        = 64 / 30
ROOM_CUT_OFF      = 32 * 3
ROOM_TYPES        = [ 'empty', 'wall', 'hole' ]
TILE_SIZE         = 16


class @GGJScene extends Scene

  g: undefined
  texture: undefined
  loader: undefined
  player: undefined
  topRoom: undefined
  rooms: undefined
  _rooms: undefined
  activeRooms: undefined
  background: undefined
  stage: undefined
  midground: undefined
  foreground: undefined
  countdownText: undefined
  runText: undefined

  state: STATES.RUN
  currentSpeed: 0
  moveSpeed: 0
  isBoosting: false
  countdownComplete: false
  countdownNum: 5
  distance: 0
  hideRooms: false
  drawBounds: false


  constructor: (@name, @game) ->
    super(@name, @game)
    @type = 'GGJScene'
    @init()
    @loadAssets()


  init: () =>
    @rooms = {}
    @_rooms = []
    @activeRooms = []
    @collisionsData = []

    @background = new PIXI.DisplayObjectContainer()
    @midground = new PIXI.DisplayObjectContainer()
    @foreground = new PIXI.DisplayObjectContainer()

    @g = new PIXI.Graphics()
    @player = new GGJPlayer(@game, this)

    # We want to store this one differently
    @topRoom = new GGJRoom('topRoom', @game, this)
    # Make the other room types
    for type in ROOM_TYPES
      @rooms[type] = new GGJRoom(type, @game, this) 


  # setup all of the managers
  loadAssets: () =>
    @texture = PIXI.Texture.fromImage("img/test.png")
    PIXI.Texture.addTextureToCache(@texture, 'player')
    atlas = ['img/ggj/sprites.json']
    @loader = new PIXI.AssetLoader(atlas)
    @loader.load()
    @loader.onComplete = () => @assetsLoaded = true


  load: () =>
    unless @assetsLoaded
      return @loader.onComplete = () =>
        @assetsLoaded = true
        @load()

    @game.stage.addChild(this)
    @addChild(@background)
    @addChild(@midground)
    @addChild(@foreground)
    @addChild(@g)

    @topRoom.y = 0
    @topRoom.ready()
    @activeRooms.push(@topRoom)

    @player.ready()
    @currentSpeed = INIT_SPEED
    @state = STATES.RUN
    @isReady = true
    @distance = 0
    @readyCountdown()
    textStyle = {
      font: '50px Arial'
      fill: '#F7E68A' 
      stroke: "#5C5821"
      strokeThickness: 4
    }
    @gameoverText = new PIXI.Text("Game Over.", textStyle)
    @gameoverText.anchor.x = 0.5
    @gameoverText.anchor.y = 0.5
    @gameoverText.x = @game.canvas.width * 0.5
    @gameoverText.y = @game.canvas.height * 0.5
    

  unload: () =>
    @isReady = false
    @countdownComplete = false
    @countdownNum = 3

    @foreground.removeChild(@gameoverText)

    @player.unload()
    @removeChild(@background)
    @removeChild(@midground)
    @removeChild(@foreground)
    @removeChild(@g) 

    @game.stage.removeChild(@countdownText)
    @game.stage.removeChild(@runText)
    @game.stage.removeChild(this)

    while @activeRooms.length > 0
      @activeRooms.pop().unload()
  

  reset: () =>
    @unload()
    @load()


  # Update stuff
  update: () =>
    return unless @isReady

    if @state is STATES.RESET
      return @reset() if @game.input.mouseDown or @game.input.touch or @game.input.release[@game.input.KEY['SPACEBAR']]


    if @game.input.release[@game.input.KEY['SPACEBAR']]
      @state = if @state is STATES.RUN then STATES.PAUSE else STATES.RUN

    if @game.input.release[@game.input.KEY['0']]
      @drawBounds = !@drawBounds

    if @game.input.release[@game.input.KEY['9']]
      @toggleHideRooms()

    if @countdownComplete

      if @state is STATES.RUN
        @doRunState()

    else

      @countdownText.scale.x += (1 / 30)
      @countdownText.scale.y += (1 / 30)



  # The Render part of the loop
  render: () =>
    return unless @isReady
    @g.clear()
    @player.render()

    if @drawBounds
      bounds = @player.aabb
      @g.lineStyle(2, 0xff0000)
      @g.drawRect(bounds.left, bounds.top, bounds.width, bounds.height)

      for i in [0...@activeRooms.length] by 1
        r = @activeRooms[i]
        r.drawBounds(@g)

    # check if we need to add a new room to the end
    last = @activeRooms.length - 1
    lastRoom = @activeRooms[last]
    lastRoomBottom = lastRoom.y + lastRoom.height
    if lastRoomBottom < @game.canvas.height + ROOM_CUT_OFF
      @addRoom(lastRoomBottom)

    # test for rooms we can remove
    for i in [0...@activeRooms.length] by 1
      room = @activeRooms[i]
      continue unless room
      room.render()
      if room.y + room.heigth < -ROOM_CUT_OFF
        room.unload()
        toRemove.push(i)
        
    # remove them
    while toRemove.length > 0
      index = toRemove.pop()
      @activeRooms.splice(index, 1)


  readyCountdown: () =>
    x = @game.canvas.width * 0.5 
    y = @game.canvas.height * 0.3
    textStyle = {
      font: '50px Arial'
      fill: '#F7E68A' 
      stroke: "#5C5821"
      strokeThickness: 4
    }
    @countdownText = new PIXI.Text("#{@countdownNum}", textStyle)
    @countdownText.anchor.x = 0.5
    @countdownText.anchor.y = 0.5
    @countdownText.position.x = x
    @countdownText.position.y = y

    @runText = new PIXI.Text("Run", textStyle)
    @runText.anchor.x = 0.5
    @runText.position.x = x
    @runText.position.y = y

    @game.stage.addChild(@countdownText)
    @displayCountdown()


  displayCountdown: () =>
    if @countdownNum is 0
      @game.stage.removeChild(@countdownText)
      @game.stage.addChild(@runText)
      @countdownComplete = true
      setTimeout () =>
          @game.stage.removeChild(@runText)
        , 500

    else
      @countdownText.setText("#{@countdownNum}")
      @countdownText.scale.x = 1
      @countdownText.scale.y = 1
      setTimeout () =>
          @countdownNum -= 1
          @displayCountdown()
        , 1000


  ###
  # 
  # Go Through the RUN State behaviour
  # 
  ###
  doRunState: () =>
    for i in [0..@activeRooms.length] by 1
      room = @activeRooms[i]
      continue unless room
      dy = @currentSpeed
      @distance += dy
      room.y -= dy
      room.update()

    if @game.input.current[@game.input.KEY['W']] or @game.input.current[@game.input.KEY['ARROW_UP']]
      @player.y -= @currentSpeed
    else if @game.input.current[@game.input.KEY['S']] or @game.input.current[@game.input.KEY['ARROW_DOWN']]
      @player.y += MOVE_SPEED

    if @game.input.current[@game.input.KEY['A']] or @game.input.current[@game.input.KEY['ARROW_LEFT']]
      @player.x -= MOVE_SPEED
    else if @game.input.current[@game.input.KEY['D']] or @game.input.current[@game.input.KEY['ARROW_RIGHT']]
      @player.x += MOVE_SPEED


    if @game.input.mouseDown or @game.input.touch
      @moveSpeed = MOVE_SPEED
      pos = @game.input.offsetPosition(@game.canvas)
      deltaX = pos.x - @player.x
      deltaY = pos.y - @player.y
      distanceSquared = Math.abs((deltaX * deltaX) + (deltaY * deltaY))

      if distanceSquared > MOVE_THREASHOLD
        distance =  Math.sqrt(distanceSquared)
        deltaXNorm = deltaX / distance
        deltaYNorm = deltaY / distance
        @moveSpeed = BOOST_SPEED if distanceSquared > BOOST_THREASHOLD
        @player.x += deltaXNorm * @moveSpeed
        @player.y += deltaYNorm * @moveSpeed

    @player.update()

    for i in [0..@activeRooms.length] by 1
      room = @activeRooms[i]
      continue unless room
      bounds = @player.aabb

      if room.collisionTest(bounds)
        px = 0
        py = 0
        if room.doCollision(@player, @collisionsData)
          while @collisionsData.length > 0
            data = @collisionsData.pop()
            switch data.type
              when 'hole'
                if Math.abs(data.px) > TILE_SIZE or Math.abs(data.py) > TILE_SIZE
                  @doGameOver()
              else
                px = if px is 0 then data.px else if data.px isnt 0 then Math.min(data.px, px) else px
                py = if py is 0 then data.py else if data.py isnt 0 then Math.min(data.py, py) else py
          @player.x -= px
          @player.y -= py


  doGameOver: () =>
    @state = STATES.RESET
    @foreground.addChild(@gameoverText)


  addRoom: (y) =>
    newRoom = Random.inHash(@rooms).clone()
    newRoom.y = y
    newRoom.ready()
    @activeRooms.push(newRoom)


  toggleHideRooms: () =>
    @hideRooms = !@hideRooms
    for i in [0...@activeRooms.length] by 1
      r = @activeRooms[i]
      if @hideRooms
        @background.removeChild(r.background)
        @stage.removeChild(r.walls)
        @foreground.removeChild(r.foreground)
      else
        @background.addChild(r.background)
        @stage.addChild(r.walls)
        @foreground.addChild(r.foreground)


pos = null
deltaX = 0
deltaY = 0
distanceSquared = 0
distance = 0
deltaXNorm = 0
deltaYNorm = 0
toRemove = []
