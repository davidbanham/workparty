cp = require 'chipmunk'
Facey = require 'facey'

document.addEventListener 'face_appeared', ->
  console.log 'a wild face appeared!'

document.addEventListener 'face_vanished', ->
  console.log 'face vanished'

document.addEventListener 'DOMContentLoaded', ->
  videoInput = document.getElementById('inputVideo')
  canvasInput = document.getElementById('inputCanvas')

  face = new Facey(videoInput, canvasInput)
