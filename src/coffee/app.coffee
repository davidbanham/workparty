cp = require 'chipmunk'
require 'angular/angular'
md5 = require 'MD5'
qc = require 'rtc-quickconnect'

Facey = require 'facey'

app = angular.module 'workparty', []

app.config ($httpProvider) ->
  $httpProvider.defaults.useXDomain = true
  delete $httpProvider.defaults.headers.common['X-Requested-With']

app.controller 'remotes', ($scope, $rootScope, $http) ->
  $scope.team = team = {}

  iceServers = [
    {
      url: 'turn:yankee.davidbanham.com:3478?transport=udp'
      credential: 'lol'
      username: 'internet'
    }
    {
      url: 'turn:yankee.davidbanham.com:3478?transport=tcp'
      credential: 'lol'
      username: 'internet'
    }
  ]
  qc 'http://switchboard.davidbanham.com', {room: 'workparty', iceServers: iceServers }
    .createDataChannel 'faces'
    .on 'peer:leave', (id) ->
      console.log 'peer', id, 'has left the building'
      delete team[id]
      $scope.$apply()
    .on 'faces:open', (dc, id) ->
      dc.onmessage = (evt) ->
        console.log 'peer', id, 'says', evt.data
        #gross
        if evt.data is 'present'
          team[id].present = true
        else if evt.data is 'away'
          team[id].present = false
        else
          parsed = JSON.parse evt.data
          team[id] = parsed
          hash = md5 parsed.email
          team[id].hash = hash
          window['fuckgravatar'+hash] = (data) ->
            team[id].avatar = data
          $http.jsonp "http://secure.gravatar.com/#{hash}.json?callback=#{'fuckgravatar'+hash}"
        $scope.$apply()

      team[id] = {}
      $scope.$apply()

      console.log 'connection established to', id

      dc.send JSON.stringify
        email: localStorage.getItem 'email'
        present: $rootScope.face.found

      document.addEventListener 'face_appeared', ->
        dc.send 'present'

      document.addEventListener 'face_vanished', ->
        dc.send 'away'

app.controller 'locals', ($scope, $http, $rootScope) ->

  $scope.email = email = localStorage.getItem 'email'
  unless email
    email = prompt "What's your email address?"
    localStorage.setItem 'email', email
    window.location.reload()

  window.self_callback = (data) ->
    $scope.avatar = data.entry[0]

  $http.jsonp "https://secure.gravatar.com/#{md5 email}.json?callback=self_callback"

  document.addEventListener 'face_appeared', ->
    console.log 'a wild face appeared!', $scope.face
    $scope.$apply()

  document.addEventListener 'face_vanished', ->
    console.log 'face vanished', $scope.face
    $scope.$apply()

  videoInput = document.getElementById('inputVideo')
  canvasInput = document.getElementById('inputCanvas')

  $rootScope.face = $scope.face = new Facey(videoInput, canvasInput)

  $scope.md5 = md5
