#= require spin

_.namespace("App");

class App.LoadingSpin
  constructor: (@root) ->
    opts =
      lines: 11
      length: 10
      width: 6
      radius: 15
      corners: 1
      rotate: 0
      direction: 1
      color: '#000'
      speed: 1
      trail: 60
      shadow: false
      hwaccel: false
      className: 'spinner'
      zIndex: 2e9
      top: '50%'
      left: '50%'
    @spinner = new Spinner(opts)

  start: ->
    @spinner.spin(@root)

  stop: ->
    @spinner.stop()

