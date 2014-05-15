devconfig = require 'devconfig'
mediator = require 'mediator'

# Application-specific utilities
# ------------------------------

# Delegate to Chaplin’s utils module.
utils = Chaplin.utils.beget Chaplin.utils

Minilog
  .enable()
  .pipe new Minilog.backends.jQuery {url: devconfig.api_logs, interval: 5000}

minilog = Minilog 'tophubbers'

_(utils).extend
  # Logging helper
  # ---------------------
  log: (message, level='debug') ->
    if devconfig.dev and not devconfig.debug_minilog then console.log message
    else if level
      console.log message if devconfig.verbose and level is 'debug'
      text = JSON.stringify message
      message = if text.length > 512 then "size exceeded" else message

      data =
        message: message
        time: (new Date()).getTime()
        user: mediator?.user?.get('email')

      minilog[level] data if level isnt 'debug'

  saveJSON: (store) ->
    if devconfig.dual_storage
      ids = localStorage.getItem(store).split(',')
      data = (JSON.parse(localStorage.getItem "#{store}#{id}") for id in ids)
      collection = JSON.stringify data
      href = "data:application/json;charset=utf-8,#{escape collection}"
      mediator.download["#{store}_href"] = href

  setSynced: (collection, store) ->
    if mediator[collection].local
      localStorage.setItem("#{store}:synced", true)

  preloadImages: (collection) ->
  # http://stackoverflow.com/a/10240297/408556
    imgs = collection.paginator().collection.pluck 'url_s'
    preload = []
    img = new Image()
    _(imgs).each (url) ->
      img.src = url
      preload.push(img)

  _deg2dms: (deg) ->
  # http://stackoverflow.com/a/5786627/408556
  # http://stackoverflow.com/a/5786281/408556
    deg = Math.abs(deg)
    d = Math.floor deg
    minfloat = (deg - d) * 60
    m = Math.floor minfloat
    secfloat = (minfloat - m) * 60
    s = Math.round (minfloat - m) * 60
    if s is 60
      m++
      s = 0

    if m is 60
      d++
      m = 0

    deg: Math.abs(d), min: Math.abs(m), sec: Math.abs(s)

  deg2dms: (deglat, deglon) ->
    lat = {}
    lon = {}
    lat.dir = if deglat > 0 then 'N' else 'S'
    lon.dir = if deglon > 0 then 'E' else 'W'
    _(lat).extend @_deg2dms deglat
    _(lon).extend @_deg2dms deglon
    lat: lat, lon: lon

  mergePortfolio: (portfolio, screenshots) ->
    cltn = portfolio.mergeModels screenshots, ['url_s'], 'small'
    cltn = cltn.mergeModels screenshots, ['url_m'], 'main'
    cltn = cltn.mergeModels screenshots, ['url_sq'], 'square'
    options = {placeholder: false, n: 3}
    collection = cltn.mergeModels screenshots, ['url_e'], 'extra', options
    return collection

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
    @log 'making ' + selection

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
    chart.dispatch.on 'stateChange', -> @log 'stateChange'
    chart

# Prevent creating new properties and stuff.
Object.seal? utils

module.exports = utils
