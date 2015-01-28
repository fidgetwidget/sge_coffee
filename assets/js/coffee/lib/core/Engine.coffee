# TODO: make tests that check the browsers ability to do the things the
#       engine relies on. If any of them fail, display an alert that
#       tells the user their browser doesn't support x,y,z feature needed...


class @Engine

  pause: false
  debug: true
  then: 0
  fpsInterval:  Math.floor(1000/30)

  ruler:    undefined
  stats:    undefined

  input:    undefined
  entities: undefined # entitiy manager
  scenes:   undefined # scene manager

  stage:    undefined # the current scene stage
  renderer: undefined
  canvas:   undefined

  constructor: (canvas_id) ->
    canvas_id = canvas_id || 'game_canvas'
    @canvas = document.getElementById(canvas_id)
    @_init(@canvas)
    @_load()


  ###
  # 
  # Initialize
  # 
  ###
  
  # setup all of the managers
  _init: (canvas) =>
    @input = new InputHandler()
    @entities = new EntityManager()
    @scenes = new SceneManager()
    @_initStage(canvas)
    @_initDebug()
    @init(canvas)

  # setup the stage and renderer
  _initStage: (canvas) =>
    @width = canvas.width
    @height = canvas.height
    @stage = new PIXI.Stage(0x66FF99)
    @renderer = PIXI.autoDetectRenderer(@width, @height, { view: canvas })

    @scenes.scale.x = @width / canvas.offsetWidth
    @scenes.scale.y = @height / canvas.offsetHeight

  # right now I am just using stats.js 
  _initDebug: () =>
    @ruler = new TimeRuler(@fpsInterval)
    @ruler.domElement.style.position = 'fixed'
    @ruler.domElement.style.bottom = '0px'
    @ruler.domElement.style.left = '0px'
    @ruler.domElement.style.width = '100%'
    document.body.appendChild( @ruler.domElement )

    @stats = new Stats()
    @stats.domElement.style.position = 'fixed'
    @stats.domElement.style.bottom = @ruler.domElement.style.height
    @stats.domElement.style.right = '0px'
    document.body.appendChild( @stats.domElement )

    @text = document.createElement('div')
    @text.style.position = 'fixed'
    @text.style.bottom = @ruler.domElement.style.height
    @text.style.left = '0px'
    @text.style.right = @stats.domElement.style.width
    @text.style.height = '20px'
    @text.style.lineHeight = '20px'
    @text.style.fontSize  = '14px'
    @text.style.fontFamily = 'mono'
    document.body.appendChild( @text )


  init: (canvas) =>
    # Custom init code goes here


  ###
  # 
  # Loading
  # 
  ###

  _load: () =>
    @_loadAssets()
    @load()
    @_loadComplete()

  # Load the assets
  _loadAssets: () =>
    # load all of the default assets here
    
  # Once the assets are loaded, start the game loop
  _loadComplete: () =>
    # Start the game loop
    @clock = performance.now()
    requestAnimFrame( @loop )
    # in case I want to switch to a set Interval loop instead... 
    # setInterval( @loop, @fpsInterval )


  load: () =>
    # Custom Load Code goes here


  ###
  # 
  # Game Loop
  # 
  ###

  # The base Game Loop
  loop: (now) =>

    if (@pause)
      return

    delta = now - @clock
    requestAnimFrame( @loop )

    if @debug
      @stats.begin()
      @ruler.begin()

    @ruler.addMarker('update', '#008629') if @debug
    @_update()
    @ruler.endMarker('update') if @debug
    
    if true # delta > @fpsInterval
    
      @clock = now - (delta % @fpsInterval)
      @ruler.addMarker('render', '#45077A') if @debug
      @_render()
      @ruler.endMarker('render') if @debug

    if @debug
      @stats.end()
      @ruler.end()


  ###
  # 
  # Update
  # 
  ###

  # The Update part of the loop
  _update: (delta) =>
    @beforeUpdate()
    @entities.update(delta)
    @scenes.update(delta)
    @input.update(delta)
    @update(delta)
    @afterUpdate()


  beforeUpdate: () =>
    # Custom Before Update Code goes here

  update: (delta) =>
    # Custom Update Code goes here

  afterUpdate: () =>
    @input.afterUpdate()
    # Custom After Update Code goes here



  ###
  # 
  # Render
  # 
  ###

  # The Render part of the loop
  _render: () =>
    @beforeRender()
    @renderer.render(@stage)
    @scenes.render()
    @render()
    @afterRender()


  beforeRender: () =>
    # Custom Before Render Code goes here

  render: () =>
    # Custom Render Code goes here

  afterRender: () =>
    # Custom After Render Code goes here


  ###
  # 
  # Helpers
  # 
  ###

  stop: () =>
    @pause = true

  start: () =>
    @pause = false


