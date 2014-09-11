headtrackr = require 'headtrackr'

emit = (event) ->
  setTimeout ->
    document.dispatchEvent event
  , 0

Face = (videoInput, canvasInput) ->
  @exists = ->
    emit @events.appeared unless @found
    @found = new Date()
    @reset()

  @found = false

  @interval = null
  @events =
    appeared: new Event 'face_appeared'
    vanished: new Event 'face_vanished'
  @reset = ->
    clearInterval @interval
    @interval = setInterval =>
      emit @events.vanished if @found
      @found = false
    , 10000

  @reset()

  htracker = new headtrackr.Tracker
    smoothing: false
    ui: false

  htracker.init videoInput, canvasInput
  htracker.start()

  setInterval ->
    htracker.stop()
  , 10000

  setTimeout ->
    setInterval ->
      htracker.start()
    , 10000
  , 7000

  document.addEventListener 'headtrackingEvent', (ev) =>
    @exists()

module.exports = Face
