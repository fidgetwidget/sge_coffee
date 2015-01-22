
class @TimeRuler

  markers: {}
  _init: false
  domElement: undefined
  interval: Math.floor(1000/30)
  start: 0


  constructor: (interval) ->
    @interval = interval
    @initRuler()

  # create the elm for the ruler
  initRuler: () =>
    elm = document.createElement('div')
    elm.id = "time_ruler"
    elm.style.height    = '20px'
    elm.style.backgroundColor = '#efefef'
    @domElement = elm
    @_init = true

  # create the elm for a marker
  makeMarker: (name) =>
    elm = document.createElement('div')
    elm.title = name
    elm.class = "time-ruler-marker-#{name}"
    elm.style.position  = 'absolute'
    elm.style.height    = '20px'
    @domElement.appendChild(elm)
    @markers[name].elm = elm

  # start the loop
  begin: () =>
    @start = performance.now()
    @initRuler() unless @_init

  # end the loop and adjust the values of the markers
  end: () =>
    @drawMarkers()


  drawMarkers: () =>
    for key, marker of @markers
      @drawMarker(marker)


  drawMarker: (marker) =>
    dl = marker.start - @start
    d  = marker.end - marker.start
    w  = @domElement.offsetWidth
    n  = @interval
    marker.elm.style.left   = "#{Math.floor((dl / n) * w)}px"
    marker.elm.style.width  = "#{Math.floor(( d / n) * w)}px"

  # add a new marker, or update an existing one
  addMarker: (name, color='#353535') =>
    if @markers[name] is undefined
      @markers[name] = {} 
      @makeMarker(name)
    @markers[name].start = performance.now()
    unless @markers[name].color is color
      @markers[name].color = color
      @markers[name].elm.style.backgroundColor = color

  # mark the end time for a given marker
  endMarker: (name) =>
    return if @markers[name] is undefined
    @markers[name].end = performance.now()


