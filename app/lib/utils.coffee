config = require 'config'
Chaplin = require 'chaplin'
mediator = Chaplin.mediator

# Application-specific utilities
# ------------------------------

# Delegate to Chaplin’s utils module.
utils = Chaplin.utils.beget Chaplin.utils

Minilog
  .enable()
  .pipe new Minilog.backends.jQuery {url: config.api_logs, interval: 5000}

minilog = Minilog 'tophubbers'

_(utils).extend
  makeChart: (data, selection, resize=true) ->
    retLab = (data) -> data.label
    retVal = (data) -> data.value
    formatMinutes = (d) ->
      time = d3.time.format("%I:%M %p")(new Date 2013, 0, 1, 0, d)
      if time.substr(0,1) is '0' then time.substr(1) else time

    minTime = 0
    maxTime = 24
    chartRange = [minTime * 60, maxTime * 60]
    color = 'steelblue'
    console.log 'making ' + selection

    chart = nv.models.multiBarHorizontalChart()
      .x(retLab)
      .y(retVal)
      .forceY(chartRange)
      .yDomain(chartRange)
      .margin({top: 0, right: 110, bottom: 30, left: 80})
      .showValues(false)
      .tooltips(true)
      .stacked(true)
      .showLegend(false)
      .barColor([d3.rgb(color)])
      .transitionDuration(100)
      .showControls(false)

    chart.yAxis
      .scale(chart.y)
      .tickFormat(formatMinutes)

    chart.multibar.yScale().clamp true

    d3.select(selection)
      .datum(data)
      .call(chart)

    nv.utils.windowResize(chart.update) if resize
    chart.dispatch.on 'stateChange', -> console.log 'stateChange'
    chart

  # Logging helper
  # ---------------------
  log: (message, level='debug') ->
    if config.dev and not config.debug_minilog then console.log message
    else if level
      console.log message if config.debug_prod_verbose and level is 'debug'
      text = JSON.stringify message
      message = if text.length > 512 then "size exceeded" else message

      data =
        message: message
        time: (new Date()).getTime()
        user: mediator?.user?.get('email')

      minilog[level] data if level isnt 'debug'

# Prevent creating new properties and stuff.
Object.seal? utils

module.exports = utils
