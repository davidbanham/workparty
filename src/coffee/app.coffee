cp = require 'chipmunk'
require 'angular/angular'

Facey = require 'facey'

app = angular.module 'workparty', []

app.controller 'test', ($scope) ->
  document.addEventListener 'face_appeared', ->
    console.log 'a wild face appeared!', $scope.face
    $scope.$apply()

  document.addEventListener 'face_vanished', ->
    console.log 'face vanished', $scope.face
    $scope.$apply()

  videoInput = document.getElementById('inputVideo')
  canvasInput = document.getElementById('inputCanvas')

  $scope.face = new Facey(videoInput, canvasInput)
