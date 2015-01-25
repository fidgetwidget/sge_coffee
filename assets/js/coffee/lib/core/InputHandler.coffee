###
# Input Handler
#   The goal is to: 
#   - create an easy way to attach key bindings to a set of actions
#   - trigger the actions 'event' on the given binding key down/up/held/etc
#     eg. game.trigger "#{action.name}:#{action.eventType}"
###

class @InputHandler

  actions:    undefined
  current:    undefined
  _released:  undefined
  release:    undefined
  prev:       undefined
  mouseDown:  false
  touch:      false
  mouseClick: false
  lastMouseX: 0
  lastMouseY: 0
  mouseDelta: undefined
  KEY:        undefined


  constructor: () ->
    @actions    = {}
    @current    = {}
    @_released  = []
    @release    = {}
    @mouseDelta = [0, 0]
    @reset()
    @initKeys()
    @bindEvents()


  ###
  # 
  # Init
  # 
  ###

  # Load an action map and create the action emitters
  load: (source) =>
    #TODO: assign the actions to their respective triggers


  # 
  # Bind the Event Handlers
  # 
  bindEvents: () =>
    document.addEventListener 'keyup', @onKeyUp
    document.addEventListener 'keydown', @onKeyDown

    document.addEventListener 'mouseup', @onMouseUp
    document.addEventListener 'mousedown', @onMouseDown
    document.addEventListener 'mousemove', @onMouseMove
    document.addEventListener 'click', @onMouseClick

    document.addEventListener 'touchstart', @onTouchStart
    document.addEventListener 'touchend', @onTouchEnd
    document.addEventListener 'touchmove', @onTouchMove

  # 
  # Init the readable names for keyCodes Object
  # 
  initKeys: () =>
    # Lifted from: https://github.com/daleharvey/pacmanhttps://github.com/daleharvey/pacman
    @KEY = {
      'BACKSPACE': 8
      'TAB': 9
      'NUM_PAD_CLEAR': 12
      'ENTER': 13
      'SHIFT': 16
      'CTRL': 17
      'ALT': 18
      'PAUSE': 19
      'CAPS_LOCK': 20
      'ESCAPE': 27
      'SPACEBAR': 32
      'PAGE_UP': 33
      'PAGE_DOWN': 34
      'END': 35
      'HOME': 36
      'ARROW_LEFT': 37
      'ARROW_UP': 38
      'ARROW_RIGHT': 39
      'ARROW_DOWN': 40
      'PRINT_SCREEN': 44
      'INSERT': 45
      'DELETE': 46
      'SEMICOLON': 59
      'WINDOWS_LEFT': 91
      'WINDOWS_RIGHT': 92
      'SELECT': 93
      'NUM_PAD_ASTERISK': 106
      'NUM_PAD_PLUS_SIGN': 107
      'NUM_PAD_HYPHEN-MINUS': 109
      'NUM_PAD_FULL_STOP': 110
      'NUM_PAD_SOLIDUS': 111
      'NUM_LOCK': 144
      'SCROLL_LOCK': 145
      'SEMICOLON': 186
      'EQUALS_SIGN': 187
      'COMMA': 188
      'HYPHEN-MINUS': 189
      'FULL_STOP': 190
      'SOLIDUS': 191
      'GRAVE_ACCENT': 192
      'LEFT_SQUARE_BRACKET': 219
      'REVERSE_SOLIDUS': 220
      'RIGHT_SQUARE_BRACKET': 221
      'APOSTROPHE': 222
    }
    # 0 - 9
    for i in [48..57] by 1
      @KEY['' + (i - 48)] = i
    # A - Z
    for i in [65..90] by 1
      @KEY['' + String.fromCharCode(i)] = i
    # NUM_PAD_0 - NUM_PAD_9
    for i in [96..105] by 1
      @KEY['NUM_PAD_' + (i - 96)] = i
    # F1 - F12
    for i in [112..123] by 1
      @KEY['F' + (i - 112 + 1)] = i

  # 
  # Reset the Input Values
  # 
  reset: () =>
    @prev = null
    @mouseDown = false
    @mouseClick = false
    @lastMouseX = null
    @lastMouseY = null
    @mouseDelta[0] = 0
    @mouseDelta[1] = 0


  ###
  # 
  # Update
  # 
  ###

  # 
  # Update Method
  # 
  update: (delta) =>
    # TODO: check for actions, and set true for use in a scene


  afterUpdate: () =>
    @mouseClick = false
    while @_released.length > 0
      keycode = @_released.pop()
      @release[keycode] = false

  ###
  # 
  # Methods
  # 
  ###

  # 
  # Get the mouse position offset by the given element
  # 
  offsetPosition: (elm) =>
    rect = elm.getBoundingClientRect()
    offsetLeft = rect.left + document.body.scrollLeft
    offsetTop = rect.top + document.body.scrollTop
    x = @lastMouseX - offsetLeft
    y = @lastMouseY - offsetTop
    return { x: x, y: y }


  ###
  # 
  # Event Handlers
  # 
  ###

  # 
  # Handle the Key Down Event
  # 
  onKeyDown: (e) =>
    @current[e.keyCode] = true # TODO: store the timestamp instead
    @prev = e.keyCode
    if e.keyCode isnt 116 and e.keyCode isnt 122 # F5 and F11
      e.stopPropagation()
      e.preventDefault()

  # 
  # Handle the Key Up Event
  # 
  onKeyUp: (e) =>
    @current[e.keyCode] = false # TODO: null instead of false for timestamp instead of true
    @release[e.keyCode] = true
    @_released.push(e.keyCode)
    if e.keyCode isnt 116 and e.keyCode isnt 122 # F5 and F11
      e.stopPropagation()
      e.preventDefault()

  # 
  # Handle the Mouse Down Event
  # 
  onMouseDown: (e) => @mouseDown = true

  # 
  # Handle the Mouse Up Event
  # 
  onMouseUp: (e) =>   @mouseDown = false

  # 
  # Handle the Mouse Click Event
  # 
  onMouseClick: (e) => 
    if e.touchces
      touch = e.touches[0] 
      e.pageX = touch.pageX
      e.pageY = touch.pageY
    @mouseClick = true
    @mouseDelta[0] = @lastMouseX - e.pageX
    @mouseDelta[1] = @lastMouseY - e.pageY
    @lastMouseX = e.pageX
    @lastMouseY = e.pageY

  # 
  # Handle the Mouse Move Event
  # 
  onMouseMove: (e) =>
    @mouseDelta[0] = @lastMouseX - e.pageX
    @mouseDelta[1] = @lastMouseY - e.pageY
    @lastMouseX = e.pageX
    @lastMouseY = e.pageY

  # 
  # Handle the Touch Start Event
  # 
  onTouchStart: (e) =>  @getTouchPosition(e)

  # 
  # Handle the Touch End Event
  # 
  onTouchEnd: (e) =>  @getTouchPosition(e)

  # 
  # Handle the Touch Move Event
  # 
  onTouchMove: (e) => @getTouchPosition(e)


  getTouchPosition: (e) =>
    touch = e.touches[0]
    return @touch = false unless touch
    @touch = true
    @mouseDelta[0] = @lastMouseX - touch.pageX
    @mouseDelta[1] = @lastMouseY - touch.pageY
    @lastMouseX = touch.pageX
    @lastMouseY = touch.pageY

