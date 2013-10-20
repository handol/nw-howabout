# Services
howaboutServices = angular.module 'howaboutServices', [ 'ng', 'ngResource' ]

# App
howaboutApp = angular.module 'howaboutApp', [ 'howaboutServices' ]

# Controllers
howaboutApp.controller 'MainController', [
  '$scope'
  '$route'
  '$location'
  '$http'
  ($scope, $route, $location, $http) ->
    $scope.onHeaderLoaded = ->

    $scope.onPlayerLoaded = ->

    # adjust scrollTop whenever click a tab based on relatedTarget and target tabs.
    $scope.tabScrollTopMap = {}
    $('#fixed-tabs a[data-toggle="tab"]').on 'shown.bs.tab', (e) ->
      $scope.tabScrollTopMap[e.relatedTarget.hash] = $(document).scrollTop()
      $scope.tabScrollTopMap[e.target.hash] = 0  if not $scope.tabScrollTopMap[e.target.hash]?
      $(document).scrollTop $scope.tabScrollTopMap[e.target.hash]
]

howaboutApp.controller 'PlayerController', [
  '$scope'
  '$route'
  '$http'
  ($scope, $route, $http) ->
    showPlayButton = ->
      $('#playButtonIcon').removeClass('icon-stop icon-pause').addClass('icon-play')
      $('#player-progress').removeClass('active')

    showPauseButton = ->
      $('#playButtonIcon').removeClass('icon-stop icon-play').addClass('icon-pause')
      $('#player-progress').addClass('active')

    showStopButton = ->
      $('#playButtonIcon').removeClass('icon-play icon-pause').addClass('icon-stop')
      $('#player-progress').addClass('active')

    musicPlayer = soundManager.createSound
      id: 'musicPlayer'
      volumn: 100
      autoPlay: false
      loops: 1
      onload: ->
        setPlayButtonIcon getPlayState()
      onplay: ->
        setPlayButtonIcon getPlayState()
      onpause: ->
        setPlayButtonIcon getPlayState()
      onresume: ->
        setPlayButtonIcon getPlayState()
      onstop: ->
        setPlayButtonIcon getPlayState()
      onfinish: ->
        setPlayButtonIcon getPlayState()
        $scope.$apply ->
          $scope.durationTimeString = '0:00'
          $scope.positionTimeString = '0:00'
      whileloading: ->
        null
      whileplaying: ->
        duration = musicPlayer.duration
        durationSecs = duration / 1000
        durationSec = parseInt durationSecs % 60
        durationSec = "0#{durationSec}"  if durationSec < 10

        position = musicPlayer.position
        positionSecs = position / 1000
        positionSec = parseInt positionSecs % 60
        positionSec = "0#{positionSec}"  if positionSec < 10

        progressPercent = parseInt positionSecs * 100 / durationSecs

        $scope.$apply ->
          $scope.durationTimeString = "#{parseInt durationSecs / 60}:#{durationSec}"
          $scope.positionTimeString = "#{parseInt positionSecs / 60}:#{positionSec}"
          $scope.progressPercentStyle =
            width: "#{progressPercent}%"


    getPlayState = ->
      if musicPlayer.playState is 0
        return 'stopped'
      
      if musicPlayer.paused
        return 'paused'

      return 'playing'

    setPlayButtonIcon = (playState) ->
      switch playState
        when 'playing'
          showPauseButton()
        when 'paused'
          showPlayButton()
        when 'stopped'
          showPlayButton()
        

    $scope.onPlayButtonClick = ->
      switch getPlayState()
        when 'playing'
          musicPlayer.pause()
        when 'paused'
          musicPlayer.play()
        else
          musicPlayer.url = 'https://dl.dropboxusercontent.com/s/al83mrekonj315r/%EC%B0%B8%EA%B3%A0%20%EC%82%B4%EC%95%84%20-%20%EB%8B%A4%EC%9D%B4%EB%82%98%EB%AF%B9%20%EB%93%80%EC%98%A4.mp3?token_hash=AAHc2wrTdBIp3_Zro6QOE1SWV9wjD0W4FiaYsfSXttWBQQ&dl=1'
          musicPlayer.play()

]

# app configuration
howaboutApp.config [
  '$routeProvider'
  '$locationProvider'
  ($routeProvider, $locationProvider) ->
    $routeProvider
    .when '/',
      templateUrl: 'views/main.html'
      controller: 'MainController'
    .otherwise
      redirectTo: '/'

]

# boostrapping
angular.bootstrap document, [ 'howaboutApp' ]

# SoundManager
isSoundManagerReady = false

initSoundManager = ->
  soundManager.setup
    preferFlash: false
    onready: ->
      isSoundManagerReady = true
    ontimeout: ->
      alert 'Failed to initialize SoundManager.'

initSoundManager()
