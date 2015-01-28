#= require ../lib/scene/Scene.coffee 
#= require_tree /ggjscene

STATES = {
  EDIT: 0
  RUN:  1
  DEBUG:2
}
BOOST_THREASHOLD = 180*180
MOVE_THREASHOLD = 30*30
BOOST_SPEED   = 0.25
RUN_SPEED     = 0.19
MOVE_SPEED    = 0.1
ROOM_CUT_OFF  = 32 * 3
ROOM_TYPES = [
  'empty'
  'wall'
  'hole'
]


class @GGJScene extends Scene

  g: undefined
  texture: undefined
  loader: undefined
  player: undefined
  state: STATES.RUN
  moveSpeed: 0
  isBoosting: false
  topRoom: undefined
  rooms: undefined
  _rooms: undefined
  activeRooms: undefined
  countDownComplete: false
  background: undefined
  stage: undefined
  foreground: undefined
  countdownText: undefined
  runText: undefined
  countdownNum: 5
  hideRooms: false


  constructor: (@name, @game) ->
    super(@name, @game)
    @type = 'GGJScene'
    @init()
    @loadAssets()


  init: () =>
    @rooms = {}
    @_rooms = []
    @activeRooms = []

    @background = new PIXI.DisplayObjectContainer()
    @stage = new PIXI.DisplayObjectContainer()
    @foreground = new PIXI.DisplayObjectContainer()
    @g = new PIXI.Graphics()
    @player = new GGJPlayer(@game, this)

    @addChild(@background)
    @addChild(@stage)
    @addChild(@foreground)
    @addChild(@g) 

    @topRoom = new GGJRoom('topRoom', @game, this)
    @topRoom.isFirstRoom = true
    @topRoom.high = 24

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
    @topRoom.x = 0
    @topRoom.y = 0
    @topRoom.ready()
    @activeRooms.push(@topRoom)

    @player.ready()
    @isReady = true
    @doCountdown()
    

  unload: () =>
    @isReady = false
    @countDownComplete = false
    @game.stage.removeChild(this)
    while @activeRooms.length > 0
      @activeRooms.pop()
    



  reset: () =>
    @unload()
    @load()



  # Update stuff
  update: (delta) =>
    return unless @isReady

    if @game.input.release[@game.input.KEY['SPACEBAR']]
      @state = if @state is STATES.RUN then STATES.EDIT else STATES.RUN

    if @game.input.release[@game.input.KEY['I']]
      @state = if @state is STATES.DEBUG then STATES.EDIT else STATES.DEBUG

    if @game.input.release[@game.input.KEY['O']]
      @toggleHideRooms()

    if @state is STATES.RUN

      if @countDownComplete
        @doRunState(delta)


  # The Render part of the loop
  render: () =>
    return unless @isReady
    @g.clear()
    @player.render()

    if @state is STATES.DEBUG
      bounds = @player.getAABB()
      @g.lineStyle(2, 0xff0000)
      @g.drawRect(bounds.left, bounds.top, bounds.width, bounds.height)

      for i in [0...@activeRooms.length] by 1
        r = @activeRooms[i]
        r.drawBounds(@g)

    # check if we need to add a new room to the end
    last = @activeRooms.length - 1
    lastRoom = @activeRooms[last]
    if lastRoom.y + lastRoom.height < @game.canvas.height + ROOM_CUT_OFF
      rand = Random.intBetween(0, 6)
      newRoom = if @_rooms.length > 0 and rand > 3 then @_rooms.pop() else Random.inHash(@rooms).clone()
      newRoom.ready()
      newRoom.y = lastRoom.y + lastRoom.height
      @activeRooms.push(newRoom)

    # test for rooms we can remove
    for i in [0...@activeRooms.length] by 1
      room = @activeRooms[i]
      continue unless room
      room.render()
      if room.y + room.heigth < -ROOM_CUT_OFF
        room.unload()
        toRemove.push(i)
        @_rooms.push(room) unless room.name is 'topRoom'
        
    # remove them
    while toRemove.length > 0
      index = toRemove.pop()
      @activeRooms.splice(i, 1)

  doCountdown: () =>
    x = @game.canvas.width * 0.5 
    y = @game.canvas.height * 0.3
    @countdownText = new PIXI.Text("#{@countdownNum}", {font: '50px Arial', fill: 'white' })
    @countdownText.anchor.x = 0.5
    @countdownText.position.x = x
    @countdownText.position.y = y
    @runText = new PIXI.Text("Run", {font: '50px Arial', fill: 'white' })
    @runText.anchor.x = 0.5
    @runText.position.x = x
    @runText.position.y = y

    @foreground.addChild(@countdownText)
    @displayCountdown()


  displayCountdown: () =>
    if @countdownNum is 0
      @foreground.removeChild(@countdownText)
      @foreground.addChild(@runText)
      @countdownNum = 5
      @countDownComplete = true
      setTimeout () =>
          @foreground.removeChild(@runText)
        , 500

    else
      @countdownText.setText("#{@countdownNum}")
      setTimeout () =>
          @countdownNum -= 1
          @displayCountdown()
        , 1000


  ###
  # 
  # Go Through the RUN State behaviour
  # 
  ###
  doRunState: (delta) =>
    for i in [0..@activeRooms.length] by 1
      room = @activeRooms[i]
      continue unless room
      room.y -= RUN_SPEED * delta
      room.update(delta)


    if @game.input.current[@game.input.KEY['W']] or @game.input.current[@game.input.KEY['ARROW_UP']]
      @player.y -= MOVE_SPEED * delta
    else if @game.input.current[@game.input.KEY['S']] or @game.input.current[@game.input.KEY['ARROW_DOWN']]
      @player.y += MOVE_SPEED * delta

    if @game.input.current[@game.input.KEY['A']] or @game.input.current[@game.input.KEY['ARROW_LEFT']]
      @player.x -= MOVE_SPEED * delta
    else if @game.input.current[@game.input.KEY['D']] or @game.input.current[@game.input.KEY['ARROW_RIGHT']]
      @player.x += MOVE_SPEED * delta


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
        @player.x += deltaXNorm * @moveSpeed * delta
        @player.y += deltaYNorm * @moveSpeed * delta

    @player.update(delta)

    for i in [0..@activeRooms.length] by 1
      room = @activeRooms[i]
      continue unless room
      bounds = @player.getAABB()

      if room.collisionTest(bounds)
        room.resolveCollision(@player)


  toggleHideRooms: () =>
    @hideRooms = !@hideRooms
    for i in [0...@activeRooms.length] by 1
      r = @activeRooms[i]
      if @hideRooms
        @background.removeChild(r.background)
        @background.removeChild(r.walls)
        @stage.removeChild(r.sprites)
      else
        @background.addChild(r.background)
        @background.addChild(r.walls)
        @stage.addChild(r.sprites)


pos = null
deltaX = 0
deltaY = 0
distanceSquared = 0
distance = 0
deltaXNorm = 0
deltaYNorm = 0
toRemove = []
